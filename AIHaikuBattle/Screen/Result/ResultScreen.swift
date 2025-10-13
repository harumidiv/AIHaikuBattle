//
//  ResultScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

struct ResultScreen: View {
    @Binding var isPresnetType: PresentType?
    
    var body: some View {
        VStack {
            VStack {
                HStack(alignment: .top) {
                    VStack {
                        Spacer()
                        Button(action: {
                            // TODO: ずんだもん
                        }, label: {
                            Image(systemName: "speaker.wave.2.fill")
                                .font(.system(size: 24))
                        })
                    }
                    
                    Spacer()
                    
                    VerticalTextView("夏盛り", spacing: 0)
                        .padding(.trailing)
                    VerticalTextView("ラムネの泡と", spacing: 0)
                        .padding(.trailing)
                    VerticalTextView("青い空", spacing: 0)
                    
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
            .frame(height: 200)
            
            Divider()
            
            // 下部セクション
            VStack(alignment: .leading, spacing: 20) {
                Text("95点")
                    .font(.system(size: 48, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("AIによる解説")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text("これはAIによる解説文のプレースホルダーです。ここに句に関する詳細な解説が複数行で表示されます。このテキストは、AIの分析結果に基づいて生成されることを想定しています。")
                        .font(.body)
                        .lineLimit(nil)
                }
                Spacer()
            }
            .padding()
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
}

#Preview {
    NavigationView {
        ResultScreen(isPresnetType: .constant(.ai))
    }
}
