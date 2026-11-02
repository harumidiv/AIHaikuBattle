//
//  AdsSetup.swift
//  AIHaikuBattle
//

import SwiftUI
#if canImport(AppTrackingTransparency)
import AppTrackingTransparency
#endif
#if canImport(GoogleMobileAds)
import GoogleMobileAds
#endif

enum AdsSetup {
    /// ATTの許可を求めてから広告SDKを初期化する
    /// 回答後に初期化することで、最初の広告リクエストから許可状態が反映される
    static func requestTrackingAuthorizationAndStart() async {
        #if canImport(AppTrackingTransparency)
        if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
            let status = await ATTrackingManager.requestTrackingAuthorization()
            print("ATT status: \(status.rawValue)")
        }
        #endif

        #if canImport(GoogleMobileAds)
        await MobileAds.shared.start()
        #endif
    }
}

extension EnvironmentValues {
    /// 広告SDKの初期化（ATTの回答を含む）が完了したか
    @Entry var isAdReady: Bool = false
}
