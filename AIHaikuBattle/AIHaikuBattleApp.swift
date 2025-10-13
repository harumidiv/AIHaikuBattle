//
//  AIHaikuBattleApp.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI

@main
struct AIHaikuBattleApp: App {
    var body: some Scene {
        WindowGroup {
//            TitleScreen()
            
            BattleScreen(haikuList: [
                Haiku(upper: "夏盛り", middle: "ラムネの泡と", lower: "あおいそら", name: "はるみ"),
                Haiku(upper: "秋の風", middle: "すすき揺れて", lower: "月きらり", name: "たろう"),
                Haiku(upper: "冬しずか", middle: "こたつの中で", lower: "猫まどろむ", name: "みさき"),
                Haiku(upper: "春しぶき", middle: "川面きらめき", lower: "橋の上", name: "ゆうと")
            ])
        }
    }
}
