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
    case friend
    
    var id: Self { self }
}

struct TitleScreen: View {
    @State private var isPresnetType: PresentType?
    @State private var isPresentFavoriteScreen: Bool = false
    
    var body: some View {
        NavigationView {
            content()
                .navigationTitle("AI俳句バトル💥")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isPresentFavoriteScreen.toggle()
                        }) {
                            Image(systemName: "bookmark")
                        }
                    }
                }
        }
        .fullScreenCover(item: $isPresnetType) { type in
            switch type {
            case .single:
                SakukuScreen(isPresnetType: $isPresnetType)
            case .ai:
                SakukuScreen(isPresnetType: $isPresnetType)
            case .friend:
                SakukuScreen(isPresnetType: $isPresnetType)
            }
        }
        .fullScreenCover(isPresented: $isPresentFavoriteScreen) {
            FavoriteScreen(isPresented: $isPresentFavoriteScreen)
        }
    }
    
    private func content() -> some View {
        VStack(alignment: .center, spacing: 30) {
            gamePlayButton(title: "修行", description: "ひとりで詠む") {
                isPresnetType = .single
            }
            
            gamePlayButton(title: "AIタイマン", description: "AIと俳句で対戦") {
                isPresnetType = .ai
            }
            
            gamePlayButton(title: "ともだち乱闘", description: "友達と俳句で対戦") {
                isPresnetType = .friend
            }
            
            Spacer()
        }
    }
    
    private func gamePlayButton(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 0) {
                ZStack {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 65)
                
                // 下部の詳細情報
                VStack(spacing: 8) {
                    Divider()
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 15)
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.primary, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.2), radius: 5, y: 5)
        }
        .foregroundColor(.primary)
    }
    
    var border: some View {
        Divider()
            .frame(width: 200)
            .padding(.vertical, 10)
    }
}

#Preview {
    TitleScreen()
}

