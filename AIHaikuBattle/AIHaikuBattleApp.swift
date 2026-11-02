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
    @Environment(\.scenePhase) private var scenePhase
    @State private var isAdReady = false
    @State private var isStartingAds = false

    var body: some Scene {
        WindowGroup {
            TitleScreen()
                .environment(\.isAdReady, isAdReady)
        }
        .modelContainer(for: HaikuModel.self)
        .onChange(of: scenePhase, initial: true) { _, phase in
            // ATTダイアログはアプリがアクティブな状態でないと表示されないため、アクティブになってから要求する
            guard phase == .active, !isAdReady, !isStartingAds else { return }
            isStartingAds = true
            Task {
                await AdsSetup.requestTrackingAuthorizationAndStart()
                isAdReady = true
                isStartingAds = false
            }
        }
    }
}
