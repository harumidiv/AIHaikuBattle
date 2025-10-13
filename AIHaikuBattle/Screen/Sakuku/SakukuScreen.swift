//
//  SakukuScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

struct Haiku: Hashable, Identifiable {
    let id = UUID()
    let upper: String
    let middle: String
    let lower: String
    let name: String
}

// TODO: 次の友達に回す時キーボードのフォーカスを外す

struct SakukuScreen: View {
    enum SakukuTransition: Hashable {
        case aiScore
        case battle
    }
    @Binding var isPresnetType: PresentType?
    
    @State private var haikuList: [Haiku] = []
    
    @State private var path = NavigationPath()
    
    @State private var upper = ""
    @State private var middle = ""
    @State private var lower = ""
    @State private var name = ""
    
    var navigationTitle: String {
        switch isPresnetType {
        case .single:
            return "1人で詠む"
        case .ai:
            if haikuList.isEmpty {
                return "あなたの番"
            } else {
                return "AIの番"
            }
        case .friend:
            return "\(haikuList.count+1)人目"
        case nil:
            return ""
        }
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                contentView()
            }
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            isPresnetType = nil
                        }) {
                            Image(systemName: "xmark")
                        }
                    }
                    
                    
                    // TODO: AIの読み込みが終わって入力したらバトルに移動できるようにする
//                    if isPresnetType == .ai {
//                        
//                    }
                    
                    if isPresnetType == .friend && haikuList.count >= 1 {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                path.append(SakukuTransition.battle)
                            }) {
                                HStack {
                                    Image(systemName: "burst")
                                    Text("バトル！")
                                }
                            }
                            .disabled(upper.isEmpty || middle.isEmpty || lower.isEmpty || name.isEmpty)
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
        .navigationDestination(for: SakukuTransition.self) { transition in
            let newHaiku = Haiku(upper: upper, middle: middle, lower: lower, name: name)
            let newHaikuList = haikuList + [newHaiku]
            switch transition {
            case .aiScore:
                AIScoreScreen(isPresnetType: $isPresnetType, haiku: newHaiku)
                    .navigationBarBackButtonHidden(true)
            case .battle:
                BattleScreen(isPresnetType: $isPresnetType, haikuList: newHaikuList)
                    .navigationBarBackButtonHidden(true)
            }
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
                battleButton // AIの時は入力に触られたくないから別画面にしても良いかも？dissableにするだけで良い？
            }
        case .friend:
            Spacer()
            nextSakukuButton(title: "次のともだちに回す")
        case nil:
            EmptyView()
        }
    }
    
    var battleButton: some View {
        Button(action: {
            path.append(SakukuTransition.battle)
        }, label: {
            HStack {
                Text("バトル！")
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
    
    
    private func nextSakukuButton(title: String) -> some View {
        Button(action: {
            // 1. haikuListに新しい俳句を追加
            // haikuListが@Bindingであれば、この変更は親Viewにも伝わる
            haikuList.append(Haiku(upper: upper, middle: middle, lower: lower, name: name))
            
            // 2. 入力フィールドをクリア
            upper = ""
            middle = ""
            lower = ""
            name = ""
            
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
        Button {
            path.append(SakukuTransition.aiScore)
            
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
    SakukuScreen(isPresnetType: .constant(.ai))
}
