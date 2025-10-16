//
//  BattleScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import FoundationModels

struct HaikuScore: Identifiable {
    let id: UUID = UUID()
    let haiku: Haiku
    let evaluation: HaikuEvaluation
}

struct BattleScreen: View {
    @Binding var isPresnetType: PresentType?
    
    @StateObject var voiceBoxState = VoiceBoxState()
    
    let haikuList: [Haiku]
    
    @State private var haikuScoreList: [HaikuScore] = []
    private let session = LanguageModelSession()
    
    @State private var topScore: Int = 0
    @State private var isDraw: Bool = false
    
    var body: some View {
        Group {
            if session.isResponding || haikuList.count != haikuScoreList.count {
                Spacer()
                ProgressView()
                    .controlSize(.large)
                Spacer()
            } else {
                ScrollView {
                    ForEach(haikuScoreList) { haikuScore in
                        haikuView(haikuScore: haikuScore)
                            .overlay(
                                Group {
                                    if haikuScore.evaluation.score == topScore {
                                        Image(isDraw ? "draw" : "win")
                                            .resizable()
                                            .frame(width: 300, height: 300)
                                    } else {
                                        Image("lose")
                                            .resizable()
                                            .frame(width: 300, height: 300)
                                    }
                                }
                                    .allowsHitTesting(false)
                            )
                            
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isPresnetType = nil
                        }) {
                            Image(systemName: "house")
                        }
                    }
                }
            }
        }
        .navigationTitle("バトル結果")
        .task {
            if !haikuScoreList.isEmpty { return }
            for haiku in haikuList {
                do {
                    let result = try await session.respond(
                        to: haiku.upper + haiku.middle + haiku.lower,
                        generating: HaikuEvaluation.self
                    )
                    
                    haikuScoreList.append(.init(haiku: haiku, evaluation: result.content))
                    
                } catch {
                    haikuScoreList.append(.init(haiku: haiku, evaluation: .init(score: 0, comment: "AIのスコアリングに失敗しました")))
                }
            }
            
            haikuScoreList.sort { $0.evaluation.score > $1.evaluation.score }
            
            topScore = haikuScoreList.first?.evaluation.score ?? 0
            isDraw = haikuScoreList[0].evaluation.score == haikuScoreList[1].evaluation.score
        }
    }
    
    private func haikuView(haikuScore: HaikuScore) -> some View {
        VStack(spacing: 0) {
            HaikuCardView(voiceBoxState: voiceBoxState, haiku: .init(upper: haikuScore.haiku.upper, middle: haikuScore.haiku.middle, lower: haikuScore.haiku.lower, name: haikuScore.haiku.name), haikuFont: .title2, nameFont: .caption)
                .frame(height: 200)
                .padding()
            
            
            Rectangle()
                .fill(.primary)
                .frame(height: 1)
                .edgesIgnoringSafeArea(.horizontal)
                .padding(.top)
            HStack {
                Spacer()
                Text("\(haikuScore.evaluation.score)点")
                    .font(.headline)
                Spacer()
                
                Rectangle()
                    .fill(.primary)
                    .frame(width: 1)
                    .edgesIgnoringSafeArea(.vertical)
                
                Spacer()
                NavigationLink {
                    AIScoreScreen(isPresnetType: $isPresnetType, haiku: haikuScore.haiku, evaluation: haikuScore.evaluation)
                    
                } label: {
                    Text("AI解説を見る")
                }
                
                Spacer()
            }
            .frame(height: 60)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.primary, lineWidth: 1)
        )
        .padding()
    }
}

#Preview {
    let stubs: [Haiku] = [
        Haiku(upper: "夏盛り", middle: "ラムネの泡と", lower: "あおいそら", name: "はるみ"),
        Haiku(upper: "秋の風", middle: "すすき揺れて", lower: "月きらり", name: "たろう"),
        Haiku(upper: "冬しずか", middle: "こたつの中で", lower: "猫まどろむ", name: "みさき"),
        Haiku(upper: "春しぶき", middle: "川面きらめき", lower: "橋の上", name: "ゆうと")
    ]
    BattleScreen(isPresnetType: .constant(.ai), haikuList: stubs)
}
