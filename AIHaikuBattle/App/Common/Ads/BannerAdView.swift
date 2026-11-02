//
//  BannerAdView.swift
//  AIHaikuBattle
//

import SwiftUI

#if canImport(GoogleMobileAds)
import GoogleMobileAds

/// 画面幅に合わせたアンカー アダプティブ バナー
struct BannerAdView: View {
    let adUnitID: String

    var body: some View {
        let adSize = largeAnchoredAdaptiveBanner(width: Self.screenWidth)
        BannerViewContainer(adUnitID: adUnitID, adSize: adSize)
            .frame(width: adSize.size.width, height: adSize.size.height)
            .frame(maxWidth: .infinity)
    }

    private static var screenWidth: CGFloat {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return scene?.screen.bounds.width ?? 375
    }
}

private struct BannerViewContainer: UIViewRepresentable {
    let adUnitID: String
    let adSize: AdSize

    func makeUIView(context: Context) -> BannerView {
        let banner = BannerView(adSize: adSize)
        banner.adUnitID = adUnitID
        banner.load(Request())
        return banner
    }

    func updateUIView(_ uiView: BannerView, context: Context) {}
}
#else
/// GoogleMobileAds が使えないプラットフォーム（macOS / visionOS）では何も表示しない
struct BannerAdView: View {
    let adUnitID: String
    var body: some View { EmptyView() }
}
#endif
