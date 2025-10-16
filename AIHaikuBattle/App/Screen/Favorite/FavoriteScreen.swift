//
//  FavoriteScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/14.
//

import SwiftUI
import SwiftData

struct FavoriteScreen: View {
    @Environment(\.modelContext) private var context
    @Query private var haikus: [HaikuModel]
    
    @StateObject var voiceBoxState = VoiceBoxState()
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(haikus) { haiku in
                    HaikuCardView(voiceBoxState: voiceBoxState, haiku: Haiku(haikuModel: haiku))
                        .padding()
                        .background(
                                Image("background")
                                    .resizable()
                                    .scaledToFill()
                            )
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.secondary, lineWidth: 1)
                        )
                        .padding()
                        
                }
            }
            .navigationTitle("お気に入り")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        .onAppear {
            voiceBoxState.setup()
        }
    }
}

#Preview {
    FavoriteScreen(isPresented: .constant(true))
}
