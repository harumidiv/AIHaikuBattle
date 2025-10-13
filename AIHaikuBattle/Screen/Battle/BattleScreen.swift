//
//  BattleScreen.swift
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

struct BattleScreen: View {
    let haikuList: [Haiku]
    
    var body: some View {
        ScrollView {
            ForEach(haikuList) { haiku in
                haikuView(haiku: haiku)
            }
        }
        
    }
    
    private func haikuView(haiku: Haiku) -> some View {
        VStack {
            HaikuCardView(haiku: .init(upper: haiku.upper, middle: haiku.middle, lower: haiku.lower, name: haiku.name), haikuFont: .title2, nameFont: .caption)
                .frame(height: 200)
                .padding()
                
            HStack {
                Text("95点")
                
                Divider()
                
                NavigationLink {
                    AIScoreScreen(isPresnetType: .constant(.ai), haiku: Haiku(upper: "", middle: "", lower: "", name: ""))
                    
                } label: {
                    Text("詳細を見る")
                }
            }
            .frame(height: 30)
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
    return BattleScreen(haikuList: stubs)
}
