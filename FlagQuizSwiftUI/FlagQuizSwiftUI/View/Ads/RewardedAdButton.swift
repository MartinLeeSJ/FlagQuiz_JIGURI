//
//  RewardedAdContentView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import SwiftUI
import GoogleMobileAds

struct RewardedAdButton<L: View>: View {
    @State private var showAd: Bool = false
    
    @StateObject private var coordinator = RewardedAdCoordinator()
    private let adViewControllerRepresentable = RewardedAdViewControllerRepresentable()
    
    private let userDidEarnRewardHandler: (Int) -> Void
    private let buttonLabel: () -> L
    
    
    init(
        userDidEarnRewardHandler: @escaping (Int) -> Void,
        @ViewBuilder buttonLabel: @escaping () -> L
    ) {
        self.userDidEarnRewardHandler = userDidEarnRewardHandler
        self.buttonLabel = buttonLabel
    }
    
    private var adViewControllerRepresentableView: some View {
        adViewControllerRepresentable
            .frame(width: .zero, height: .zero)
    }
    
    var body: some View {
        ZStack {
            Button {
                guard coordinator.rewardedAd != nil else { return }
                
                coordinator.showAd(from: adViewControllerRepresentable.viewController) { rewardAmount in
                    userDidEarnRewardHandler(rewardAmount)
                }
                
            } label: {
                if coordinator.rewardedAd == nil {
                    Text("광고 로드 중...")
                } else {
                    buttonLabel()
                }
            }
            .disabled(coordinator.rewardedAd == nil)
            
            if coordinator.rewardedAd != nil {
                adViewControllerRepresentableView
            }
    
        }
        .task {
            await coordinator.loadAd()
        }
    }
}


private struct RewardedAdViewControllerRepresentable: UIViewControllerRepresentable {
    let viewController = UIViewController()
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}


private class RewardedAdCoordinator: NSObject, ObservableObject, GADFullScreenContentDelegate {
    @Published var rewardedAd: GADRewardedAd?
    
    private var adUnitID: String {
        #if DEBUG
        return "ca-app-pub-3940256099942544/1712485313"
        #else
        return Bundle.main.earthCandyRewardAdID
        #endif
    }
    
    @MainActor
    func loadAd() async {
        do {
            self.rewardedAd = try await GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest())
            self.rewardedAd?.fullScreenContentDelegate = self
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        rewardedAd = nil
        Task(priority: .userInitiated) {
            await loadAd()
        }
    }
    
    func showAd(
      from viewController: UIViewController,
      userDidEarnRewardHandler completion: @escaping (Int) -> Void
    ) {
      guard let rewardedAd = rewardedAd else {
        return print("Ad wasn't ready")
      }
        
      rewardedAd.present(fromRootViewController: viewController) {
        let reward = rewardedAd.adReward
        print("Reward amount: \(reward.amount)")
        completion(reward.amount.intValue)
      }
    }
    
}

