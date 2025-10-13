//
//  SakukuScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

struct SakukuScreen: View {
    @Binding var isPresnetType: PresentType?
    
    @State private var upper = ""
    @State private var middle = ""
    @State private var lower = ""
    @State private var name = ""
    @State private var isSending = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("上の句（5文字）")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("", text: $upper)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("中の句（7文字）")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("", text: $middle)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("下の句（5文字）")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("", text: $lower)
                            .textFieldStyle(.roundedBorder)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("名前")
                            .font(.caption)
                            .foregroundColor(.gray)
                        TextField("", text: $name)
                            .textFieldStyle(.roundedBorder)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                
                NavigationLink {
                    AIScoreScreen(isPresnetType: $isPresnetType, upper: $upper, middle: $middle, lower: $lower)
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack {
                        Text("結果を見る")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                .disabled(isSending)
                .padding(.horizontal, 40)
                .padding(.top, 10)
                Spacer()
            }
            .padding()
            .navigationTitle("1人で詠む")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresnetType = nil
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
        
    }
}

#Preview {
    SakukuScreen(isPresnetType: .constant(.ai))
}
