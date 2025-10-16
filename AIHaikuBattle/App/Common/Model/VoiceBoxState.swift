//
//  VoiceBoxState.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import AVFoundation
import Combine
import voicevox_core

final class VoiceBoxState: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var message: String = ""
    @Published var isPlaying: Bool = false
    @Published var isLoadingText: String = ""
    
    private var synthesizer: OpaquePointer?
    private var audioPlayer: AVAudioPlayer?
    
    func setup() {
        setupAudioSession()
        
        // Resource URL
        let resourcePath = Bundle.main.resourcePath!
        let resourceURL = URL(fileURLWithPath: resourcePath)
        
        // Documents URL
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // リソースURL
        print("ResourcePath: \(resourceURL.path())")
        print("DocumentsPath: \(documentsURL.path())")
        
        // Create Voice Model Directory
        let voiceModelDirectoryName = "vvms"
        let vvmsDirectory = documentsURL.appendingPathComponent(voiceModelDirectoryName)
        try! createDirectoryIfNotExist(at: vvmsDirectory)
        print("VoiceModelDirectoryPath: \(vvmsDirectory.path())")
        
        // Copy to Voice Model File
        let voiceModelFileName = "0.vvm"
        let voiceModelFileURL = vvmsDirectory.appendingPathComponent(voiceModelFileName)
        try! copyFile(
            from: resourceURL.appendingPathComponent(voiceModelFileName),
            to: voiceModelFileURL
        )
        print("VoiceFilePath: \(voiceModelFileURL.path())")
        
        // Copy to Open JTalk
        let openJTalkDirectoryName = "open_jtalk_dic_utf_8-1.11"
        let openJTalkDirectory = documentsURL.appendingPathComponent(openJTalkDirectoryName)
        try! createDirectoryIfNotExist(at: openJTalkDirectory)
        print("OpenJTalkDirectoryPath: \(openJTalkDirectory.path())")
        
        // Copy to Open JTalkFiles
        let openJTalkFilenames = ["char.bin", "COPYING", "left-id.def", "matrix.bin", "pos-id.def", "rewrite.def", "right-id.def", "sys.dic", "unk.dic"]
        for filename in openJTalkFilenames {
            let fileURL = openJTalkDirectory.appendingPathComponent(filename)
            try! copyFile(
                from: resourceURL.appendingPathComponent(filename),
                to: fileURL
            )
            print("OpenJTalkFilePath(\(filename)): \(fileURL.path())")
        }
        
        // Generate VoicevoxInitializeOptions
        let initializeOptions: VoicevoxInitializeOptions = voicevox_make_default_initialize_options()
        print("Generate VoicevoxInitializeOptions")
        print("Acceleration Mode: \(initializeOptions.acceleration_mode)")
        print("Cpu Num Threads: \(initializeOptions.cpu_num_threads)")
        
        // Generate Onnxruntime
        var onnxruntime: OpaquePointer? = voicevox_onnxruntime_get()
        
        // Init Onnxruntime
        let onnxruntimeInitResultCode = voicevox_onnxruntime_init_once(&onnxruntime)
        print("OnnxruntimeInitResultCode: \(onnxruntimeInitResultCode)")
        guard onnxruntimeInitResultCode == 0 else {
            print("Onnxruntime Init Failed")
            return
        }
        
        // Load Open JTalk
        let openJTalkDicDir: UnsafeMutablePointer<CChar>! = strdup(openJTalkDirectory.path())
        var openJtalk: OpaquePointer?
        let openJtalkRcNewResultCode: Int32 = voicevox_open_jtalk_rc_new(openJTalkDicDir, &openJtalk)
        guard openJtalkRcNewResultCode == 0 else {
            print("Open JTalk RC New Failed")
            return
        }
        
        // Make Synthesizer
        // var synthesizer: OpaquePointer?
        let synthesizerNewResultCode = voicevox_synthesizer_new(onnxruntime, openJtalk, initializeOptions, &synthesizer)
        guard synthesizerNewResultCode == 0 else {
            print("Synthesizer New Failed")
            return
        }
        
        // load model
        let voiceModelPath: UnsafeMutablePointer<CChar>! = strdup(voiceModelFileURL.path())
        var voiceModelFile: OpaquePointer?
        let voiceModelFileOpenResultCode: Int32 = voicevox_voice_model_file_open(voiceModelPath, &voiceModelFile)
        guard voiceModelFileOpenResultCode == 0 else {
            print("Voice Model File Open Failed")
            return
        }
        
        // load synthesizer model
        let synthesizerLoadVoiceModelResultCode = voicevox_synthesizer_load_voice_model(synthesizer, voiceModelFile)
        guard synthesizerLoadVoiceModelResultCode == 0 else {
            print("Synthesizer Load Voice Model Failed")
            return
        }
    }
    
    
    private func setupAudioSession() {
        do {
            // カテゴリを.playbackに設定
            // playbackは、サイレントスイッチがONでも音が鳴るカテゴリ
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            // AVAudioSessionをアクティブ化
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AVAudioSessionの設定に失敗しました: \(error.localizedDescription)")
        }
    }
    
    func playVoice(message: String) {
        self.isLoadingText = message
        self.isPlaying = true
        
        // 2. 重い音声合成処理をバックグラウンドスレッドに任せる
        DispatchQueue.global(qos: .userInitiated).async {
            let ttsOptions = voicevox_make_default_tts_options()
            let text = strdup(message)
            let styleId = 3
            var wavLength: UInt = 0
            var wavBuffer: UnsafeMutablePointer<UInt8>? = nil
            
            // この関数が完了するまでUIはフリーズしない
            let synthesizerTtsResultCode = voicevox_synthesizer_tts(self.synthesizer, text, VoicevoxStyleId(styleId), ttsOptions, &wavLength, &wavBuffer)
            
            free(text) // Cの関数で確保したメモリは解放する
            
            // エラー処理
            guard synthesizerTtsResultCode == 0, let wavBuffer = wavBuffer else {
                print("Synthesizer Text to Speach Failed")
                // 失敗した場合も、メインスレッドでUIの状態を元に戻す
                DispatchQueue.main.async {
                    self.isLoadingText = ""
                    self.isPlaying = false
                }
                return
            }
            
            let data = Data(bytes: wavBuffer, count: Int(wavLength))
            voicevox_wav_free(wavBuffer) // ライブラリが確保したメモリを解放する
            
            // 3. 処理が終わったら、メインスレッドに戻ってUIを更新し、音声を再生する
            DispatchQueue.main.async {
                do {
                    self.audioPlayer = try AVAudioPlayer(data: data)
                    self.audioPlayer?.delegate = self
                    self.audioPlayer?.prepareToPlay()
                    
                    // 読み込みが完了したので、ProgressViewを非表示にする
                    self.isLoadingText = ""
                    
                    // 音声を再生する
                    self.audioPlayer?.play()
                } catch {
                    print("Failed to Play Audio: \(error)")
                    // エラーが起きてもUIの状態を元に戻す
                    self.isLoadingText = ""
                    self.isPlaying = false
                }
            }
        }
    }
    
    private func createDirectoryIfNotExist(at url: URL) throws {
        // すでに存在していれば何もしない
        if FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
            return
        }
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func copyFile(from sourceURL: URL, to destinationURL: URL) throws {
        // すでにファイルが存在していたらスキップ
        if FileManager.default.fileExists(atPath: destinationURL.path) {
            return
        }
        try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
    }
    
    // MARK: - AVAudioPlayerDelegate
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        DispatchQueue.main.async {
            self.isPlaying = false
        }
    }
}
