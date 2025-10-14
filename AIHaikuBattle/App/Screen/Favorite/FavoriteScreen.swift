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
    
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(haikus) { haiku in
                    HaikuCardView(haiku: Haiku(haikuModel: haiku))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.primary, lineWidth: 1)
                        )
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
    }
}

#Preview {
    FavoriteScreen(isPresented: .constant(true))
}
