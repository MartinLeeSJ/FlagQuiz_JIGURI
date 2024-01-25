//
//  BannerAdView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import SwiftUI
import GoogleMobileAds

struct BannerAdContentView: View {
    var body: some View {
        BannerAdView()
    }
}

private struct BannerAdView: UIViewControllerRepresentable {
    @State private var viewWidth: CGFloat = .zero
    private let bannerAdView = GADBannerView()
    //TODO: - 실제 광고 유닛아이디 적용하기
    private let adUnitID: String =  "ca-app-pub-5402872764357733/2692196617"
    
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let bannerAdViewController = BannerAdViewController()
        bannerAdView.adUnitID = adUnitID
        bannerAdView.rootViewController = bannerAdViewController
        bannerAdViewController.view.addSubview(bannerAdView)
        
        NSLayoutConstraint.activate([
            bannerAdView.centerYAnchor.constraint(
            equalTo: bannerAdViewController.view.centerYAnchor),
            bannerAdView.centerXAnchor.constraint(equalTo: bannerAdViewController.view.centerXAnchor),
        ])
        // Tell the bannerViewController to update our Coordinator when the ad
        // width changes.
        bannerAdViewController.delegate = context.coordinator
        return bannerAdViewController
    }
        
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard viewWidth != .zero else { return }
        bannerAdView.adSize =  GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerAdView.load(GADRequest())
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    fileprivate class Coordinator: NSObject, BannerAdViewControllerWidthDelegate {
        let parent: BannerAdView
        
        init(_ parent: BannerAdView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewControllerWidthDelegate methods
        func bannerAdViewController(_ bannerAdViewController: BannerAdViewController, didUpdate width: CGFloat) {
            // Pass the viewWidth from Coordinator to BannerView.
            parent.viewWidth = width
        }
    }
}

