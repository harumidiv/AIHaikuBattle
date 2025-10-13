//
//  TitleScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

enum PresentType: Identifiable, Hashable {
    case single
    case ai
    case double
    case favorite
    case tutorial
    
    var id: Self { self }
}

struct TitleScreen: View {
    @State private var isPresnetType: PresentType?
    
    var body: some View {
        content()
            .fullScreenCover(item: $isPresnetType) { type in
                switch type {
                case .single:
                    SakukuScreen(isPresnetType: $isPresnetType)
                case .ai:
                    SakukuScreen(isPresnetType: $isPresnetType)
                case .double:
                    SakukuScreen(isPresnetType: $isPresnetType)
                case .favorite:
                    SakukuScreen(isPresnetType: $isPresnetType)
                case .tutorial:
                    SakukuScreen(isPresnetType: $isPresnetType)
                }
            }
    }
    
    private func content() -> some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                
                
                Button("", systemImage: "info.circle") {
                    isPresnetType = .tutorial
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Spacer()
                    Text("ひとりで")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                Divider()
                
                Button(action: {
                    isPresnetType = .single
                }) {
                    Text("ひとりで詠む")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                
                // 友達と遊ぶモードのセクション
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("だれかと")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Divider()
                    
                    Button(action: {
                        isPresnetType = .ai
                    }) {
                        Text("AIと詠む")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                    Button(action: {
                        isPresnetType = .double
                    }) {
                        Text("ふたりで詠む")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("おもひで")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    Divider()
                    
                    Button(action: {
                        isPresnetType = .favorite
                    }) {
                        Text("句集")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                    
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    TitleScreen()
}
