//
//  HaikuCardView.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import SwiftData

struct HaikuCardView: View {
    @StateObject var viewState = VoiceBoxState()
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
            .onAppear {
                viewState.setup()
            }
    }
    
    private func haikuView() -> some View {
        HStack(alignment: .top) {
            VStack {
                Spacer()
                ZStack(alignment: .bottomLeading) {
                    Button(action: {
                        let text = haiku.upper + "  " + haiku.middle + "  " + haiku.lower
                        viewState.playVoice(message: text)
                    }, label: {
                        Image(systemName: "speaker.wave.2.fill")
                            .font(.system(size: 24))
                    })
                    .disabled(viewState.isPlaying)
                    
                    
                    VerticalTextView(haiku.name, spacing: 0)
                        .font(nameFont)
                        .offset(x: 40, y: -40)
                }
            }
            
            Spacer()
            
            VerticalTextView(haiku.lower, spacing: 0)
                .font(haikuFont)
                .padding(.trailing)
            VerticalTextView(haiku.middle, spacing: 0)
                .font(haikuFont)
                .padding(.trailing)
            VerticalTextView(haiku.upper, spacing: 0)
                .font(haikuFont)
            
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
