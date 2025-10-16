//
//  VerticalTextView.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//


import SwiftUI

struct VerticalTextView: View {
    let text: String
    let spacing: CGFloat

    init(_ text: String, spacing: CGFloat = 4) {
        self.text = text
        self.spacing = spacing
    }

    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            ForEach(Array(text), id: \.self) { char in
                Text(String(char))
            }
        }
    }
}

#Preview {
    VerticalTextView("縦書きテキストの例です")
        .font(.title)
        .padding()
        .border(Color.gray)
}
