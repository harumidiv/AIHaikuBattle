//
//  AdUnitID.swift
//  AIHaikuBattle
//

import Foundation

/// AdMob 広告ユニットID
/// DEBUG ビルドでは Google 提供のテスト用IDを使う（本番IDを自分でタップするとアカウント停止のリスクがあるため）
enum AdUnitID {
    #if DEBUG
    static let titleBanner = "ca-app-pub-3940256099942544/2435281174"
    static let rejudgeRewarded = "ca-app-pub-3940256099942544/1712485313"
    #else
    static let titleBanner = "ca-app-pub-8522231452310619/3148613256"
    static let rejudgeRewarded = "ca-app-pub-8522231452310619/1475604788"
    #endif
}
