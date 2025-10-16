//
//  HaikuCardView.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import SwiftData

struct HaikuCardView: View {
    @ObservedObject var voiceBoxState: VoiceBoxState
    @Environment(\.modelContext) private var context
    @Query private var haikus: [HaikuModel]
    
    let haiku: Haiku
    var haikuFont: Font = .title
    var nameFont: Font = .subheadline
    
    private var isFavorite: Bool {
        haikus.contains { storedHaiku in
            storedHaiku == HaikuModel(haiku: haiku)
        }
    }
    
    var body: some View {
        haikuView()
    }
    
    private func haikuView() -> some View {
        HStack(alignment: .top) {
            VStack {
                Spacer()
                ZStack(alignment: .bottomLeading) {
                    let text = haiku.upper + "  " + haiku.middle + "  " + haiku.lower + "     " + haiku.name
                    if voiceBoxState.isLoadingText == text {
                        ProgressView()
                            .frame(width: 32, height: 32)
                    } else {
                        Button(action: {
                            voiceBoxState.playVoice(message: text)
                        }, label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 24))
                        })
                        .disabled(voiceBoxState.isPlaying)
                        .frame(width: 32, height: 32)
                    }
                    
                    
                    VerticalTextView(haiku.name, spacing: 0)
                        .font(.hudemoji(size: 18))
                        .offset(x: 40, y: -40)
                }
            }
            
            Spacer()
            
            VerticalTextView(haiku.lower, spacing: 0)
                .font(.hudemoji(size: 32))
                .padding(.trailing)
            VerticalTextView(haiku.middle, spacing: 0)
                .font(.hudemoji(size: 32))
                .padding(.trailing)
            VerticalTextView(haiku.upper, spacing: 0)
                .font(.hudemoji(size: 32))
            
            Spacer()
            
            Button(action: {
                let newHaiku = HaikuModel(haiku: haiku)
                
                if isFavorite {
                    if let haikuToDelete = haikus.first(where: { $0 == newHaiku }) {
                        context.delete(haikuToDelete)
                    }
                } else {
                    context.insert(newHaiku)
                }
                
            }, label: {
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.system(size: 24))
                    .foregroundColor(.yellow)
                    .symbolEffect(.bounce, value: isFavorite)
            })
            .sensoryFeedback(.impact, trigger: isFavorite)
            
        }
    }
}
