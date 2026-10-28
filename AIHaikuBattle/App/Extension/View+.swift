//
//  View+.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2026/10/28.
//

import SwiftUI

extension View {
    /// iPhone Duoなど横幅の広い画面で間延びしないよう、コンテンツ幅を制限して中央寄せする
    func readableContentWidth(_ maxWidth: CGFloat = 600) -> some View {
        self
            .frame(maxWidth: maxWidth)
            .frame(maxWidth: .infinity)
    }
}
