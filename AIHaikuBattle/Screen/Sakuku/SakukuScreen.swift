//
//  SakukuScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

struct Haiku: Hashable {
    let upper: String
    let middle: String
    let lower: String
    let name: String
}

struct SakukuScreen: View {
    @Binding var isPresnetType: PresentType?
    
    var haikuList: [Haiku]
    
    @State private var path = NavigationPath()
    
    @State private var upper = ""
    @State private var middle = ""
    @State private var lower = ""
    @State private var name = ""
    var body: some View {
        NavigationStack(path: $path) {
            contentView()
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
    
    private func contentView() -> some View {
        VStack(spacing: 20) {
            haikuInputView
            
            Spacer()
            
            bottomButton
        }
        .navigationDestination(for: Haiku.self) { newHaiku in
            SakukuScreen(isPresnetType: $isPresnetType, haikuList: haikuList + [newHaiku])
        }
    }
    
    @ViewBuilder
    private var bottomButton: some View {
        switch isPresnetType {
        case .single:
            Spacer()
            aiScoreButton
        case .ai:
            Spacer()
            if haikuList.isEmpty {
                nextSakukuButton(title: "AIに回す")
            } else {
                aiScoreButton // TODO バトル画面に飛ばす
            }
        case .friend:
            Spacer()
            nextSakukuButton(title: "次のともだちに回す")
            if haikuList.count >= 1 {
                aiScoreButton // TODO バトル画面に飛ばす
            }
        case nil:
            EmptyView()
        }
    }
    
    
    private func nextSakukuButton(title: String) -> some View {
        Button(action: {
            path.append(Haiku(upper: upper, middle: middle, lower: lower, name: name))
        }, label: {
            HStack {
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        })
        .disabled(upper.isEmpty || middle.isEmpty || lower.isEmpty || name.isEmpty)
        .padding(.horizontal, 40)
        .padding(.top, 10)
    }
    
    var aiScoreButton: some View {
        NavigationLink {
            AIScoreScreen(isPresnetType: $isPresnetType, haiku: Haiku(upper: upper, middle: middle, lower: lower, name: name))
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
        .disabled(upper.isEmpty || middle.isEmpty || lower.isEmpty || name.isEmpty)
        .padding(.horizontal, 40)
        .padding(.top, 10)
    }
    
    var haikuInputView: some View {
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
    }
}

#Preview {
    SakukuScreen(isPresnetType: .constant(.ai), haikuList: [])
}
