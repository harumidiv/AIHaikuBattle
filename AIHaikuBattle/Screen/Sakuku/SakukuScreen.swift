//
//  SakukuScreen.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import FoundationModels

struct Haiku: Hashable, Identifiable {
    let id = UUID()
    let upper: String
    let middle: String
    let lower: String
    let name: String
    
    init(upper: String, middle: String, lower: String, name: String) {
        self.upper = upper
        self.middle = middle
        self.lower = lower
        self.name = name
    }
    
    init(haikuModel: HaikuModel) {
        self.upper = haikuModel.upper
        self.middle = haikuModel.middle
        self.lower = haikuModel.lower
        self.name = haikuModel.name
    }
}

enum SakukuFocusFields: Hashable {
    case upper
    case middle
    case lower
    case name
    
    func next() -> SakukuFocusFields? {
        switch self {
        case .upper:
            return .middle
        case .middle:
            return .lower
        case .lower:
            return .name
        case .name:
            return nil
        }
    }
}

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
    
    private let session = LanguageModelSession()
    
    @State private var keyboardIsPresented: Bool = false
    @FocusState private var focusedField: SakukuFocusFields?
    @State private var isNeedNextBotton: Bool = false
    
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
    
    var isAI: Bool {
        isPresnetType == .ai && haikuList.count == 1
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                if isAI {
                    ZStack {
                        contentView()
                        
                        if session.isResponding {
                            ProgressView()
                        }
                    }
                } else {
                    contentView()
                }
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
                
                if isAI && !session.isResponding {
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
        .withKeyboardToolbar(keyboardIsPresented: $keyboardIsPresented, isNeedNextBotton: $isNeedNextBotton) {
            focusedField = focusedField?.next()
        }
        .onChange(of: focusedField) {
            switch focusedField {
            case .upper, .middle, .lower:
                isNeedNextBotton = true
            default:
                isNeedNextBotton = false
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
        Spacer()
        switch isPresnetType {
        case .single:
            aiScoreButton
        case .ai:
            if haikuList.isEmpty {
                nextSakukuButton(title: "AIに回す")
            }
        case .friend:
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
            haikuList.append(Haiku(upper: upper, middle: middle, lower: lower, name: name))
            
            initInputText()
            
            // ここは切り替わる前なのでai動線で次へボタンが呼ばれたタイミングで通信を走らせる
            if isPresnetType == .ai {
                Task {
                    do {
                        let result = try await session.respond(
                            to: "自由に俳句を作ってください",
                            generating: AIHaiku.self
                        )
                        name = "AI詩人"
                        upper = result.content.upper
                        middle = result.content.middle
                        lower = result.content.lower
                        
                    } catch {
                        name = "AI詩人"
                        upper = "オーバーフロー"
                        middle = "良い俳句が"
                        lower = "でてこない"
                    }
                }
            }
            
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
                    .disabled(isAI)
                    .focused($focusedField, equals: .upper)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("中の句（7文字）")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $middle)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isAI)
                    .focused($focusedField, equals: .middle)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("下の句（5文字）")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $lower)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isAI)
                    .focused($focusedField, equals: .lower)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("名前")
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField("", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .disabled(isAI)
                    .focused($focusedField, equals: .name)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
    
    private func initInputText() {
        focusedField = nil
        
        upper = ""
        middle = ""
        lower = ""
        name = ""
    }
}

#Preview {
    SakukuScreen(isPresnetType: .constant(.ai))
}
