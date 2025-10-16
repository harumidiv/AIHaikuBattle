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
        .padding()
    }
    
    private func gamePlayButton(title: String, description: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            action()
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity)
                
                Divider()
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
            }
            .padding()
            .background(
                Image("background")
                    .resizable()
                    .scaledToFill()
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.secondary, lineWidth: 4)
            )
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

