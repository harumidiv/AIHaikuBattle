//
//  AIHaikuBattleApp.swift
//  AIHaikuBattle
//
//  Created by 佐川 晴海 on 2025/10/13.
//

import SwiftUI
import SwiftData

@main
struct AIHaikuBattleApp: App {
    var body: some Scene {
        WindowGroup {
            TitleScreen()
                .onAppear {
                    for family in UIFont.familyNames.sorted() {
                        let names = UIFont.fontNames(forFamilyName: family)
                        print("Family: \(family) Font names: \(names)")
                    }
                }
        }
        .modelContainer(for: HaikuModel.self)
    }
}
