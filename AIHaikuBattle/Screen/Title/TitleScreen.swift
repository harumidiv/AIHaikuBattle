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
    
    var body: some View {
        content()
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
    }
    
    private func content() -> some View {
        VStack(spacing: 30) {
            HStack {
                Spacer()
                
                
                Button("", systemImage: "info.circle") {
//                    isPresnetType = .tutorial
                }
            }
            
            VStack(alignment: .center, spacing: 10) {
                HStack {
                    Spacer()
                    Text("ひとりで")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                border
                
                Button(action: {
                    isPresnetType = .single
                }) {
                    Text("ひとりで詠む")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.primary)
                }
                .padding(.bottom, 48)
                
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("だれかと")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    border
                    
                    Button(action: {
                        isPresnetType = .ai
                    }) {
                        Text("AIと詠む")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    
                    Button(action: {
                        isPresnetType = .friend
                    }) {
                        Text("ともだちと詠む")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.bottom, 48)
                
                VStack(alignment: .center, spacing: 10) {
                    HStack {
                        Spacer()
                        Text("保存したおもひで")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    border
                    
                    Button(action: {
//                        isPresnetType = .favorite
                    }) {
                        Text("句集")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.primary)
                    }
                    
                }
                
                Spacer()
            }
            .padding()
        }
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
