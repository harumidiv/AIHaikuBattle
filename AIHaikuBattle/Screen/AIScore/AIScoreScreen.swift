//
//  AIScoreScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import FoundationModels

struct AIScoreScreen: View {
    @StateObject var viewState = ContentViewState()
    @Binding var isPresnetType: PresentType?
    
    @Binding var upper: String
    @Binding var middle: String
    @Binding var lower: String
    
    @State private var haikuEvaluation: HaikuEvaluation?
    
    
    private let session = LanguageModelSession()
    
    var body: some View {
        content()
            .onAppear {
                viewState.setup()
            }
            .task {
                do {
                    let result = try await session.respond(
                        to: upper + middle + lower,
                        generating: HaikuEvaluation.self
                    )
                    
                    haikuEvaluation = result.content
                    
                } catch {
                    print("エラー:", error.localizedDescription)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("AI採点")
                        .font(.headline)
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresnetType = nil
                    }) {
                        Image(systemName: "house")
                    }
                }
            }
    }
    
    private func content() -> some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Spacer()
                        Button(action: {
                            let text = upper + "ーー " + middle + "ーー " + lower + "ーー "
                            viewState.playVoice(message: text)
                        }, label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 24))
                        })
                    }
                    
                    Spacer()
                    
                    VerticalTextView(lower, spacing: 0)
                        .padding(.trailing)
                    VerticalTextView(middle, spacing: 0)
                        .padding(.trailing)
                    VerticalTextView(upper, spacing: 0)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: お気に入り保存
                    }, label: {
                        Image(systemName: "star")
                            .font(.system(size: 24))
                    })
                    
                }
                .padding()
                .font(.system(size: 30))
            }
            .frame(height: 250)
            
            Divider()
            
            
            aiEvaluationView()
        }
    }
    
    @ViewBuilder
    private func aiEvaluationView() -> some View {
        if session.isResponding {
            Spacer()
            ProgressView()
            Spacer()
        } else {
            VStack(alignment: .leading, spacing: 20) {
                if let haikuEvaluation {
                    Text("\(haikuEvaluation.score)点")
                        .font(.system(size: 48, weight: .bold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("AIによる解説")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(haikuEvaluation.comment)
                            .font(.body)
                            .lineLimit(nil)
                    }
                    
                } else {
                    Text("AIが採点に失敗しました")
                        .font(.body)
                        .lineLimit(nil)
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    NavigationView {
        AIScoreScreen(isPresnetType: .constant(.ai), upper: .constant("夏盛り"), middle: .constant("ラムネの泡と"), lower: .constant("青い空"))
    }
}
