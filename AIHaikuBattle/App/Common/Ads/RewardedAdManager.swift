//
//  RewardedAdManager.swift
//  AIHaikuBattle
//

import Combine
import SwiftUI

#if canImport(GoogleMobileAds)
import GoogleMobileAds

/// リワード広告の読み込みと表示を管理する
/// 広告は一度表示すると使えなくなるため、閉じたら次の広告を読み込み直す
final class RewardedAdManager: NSObject, ObservableObject, FullScreenContentDelegate {
    private let adUnitID: String
    private var rewardedAd: RewardedAd?
    private var didEarnReward = false
    private var onReward: (() -> Void)?

    init(adUnitID: String) {
        self.adUnitID = adUnitID
    }

    func load() async {
        guard rewardedAd == nil else { return }
        do {
            let ad = try await RewardedAd.load(with: adUnitID, request: Request())
            ad.fullScreenContentDelegate = self
            rewardedAd = ad
        } catch {
            print("Rewarded ad failed to load: \(error.localizedDescription)")
        }
    }

    /// 広告を表示し、最後まで視聴されたら広告を閉じた後に `onReward` を呼ぶ
    /// 広告が用意できていない場合はユーザーを待たせないよう、そのまま `onReward` を呼ぶ
    func show(onReward: @escaping () -> Void) {
        guard let rewardedAd else {
            onReward()
            Task { await load() }
            return
        }
        didEarnReward = false
        self.onReward = onReward
        rewardedAd.present(from: nil) { [weak self] in
            self?.didEarnReward = true
        }
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        if didEarnReward {
            onReward?()
        }
        resetAndReload()
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Rewarded ad failed to present: \(error.localizedDescription)")
        onReward?()
        resetAndReload()
    }

    private func resetAndReload() {
        rewardedAd = nil
        onReward = nil
        didEarnReward = false
        Task { await load() }
    }
}
#else
/// GoogleMobileAds が使えないプラットフォーム（macOS / visionOS）では広告なしで報酬を与える
final class RewardedAdManager: ObservableObject {
    init(adUnitID: String) {}
    func load() async {}
    func show(onReward: @escaping () -> Void) { onReward() }
}
#endif
