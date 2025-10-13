//
//  HaikuCardView.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

struct HaikuCardView: View {
    @StateObject var viewState = VoiceBoxState()
    
    let haiku: Haiku
    var haikuFont: Font = .title
    var nameFont: Font = .subheadline
    
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
                // TODO: お気に入り保存
            }, label: {
                Image(systemName: "star")
                    .font(.system(size: 24))
            })
            
        }
    }
}
