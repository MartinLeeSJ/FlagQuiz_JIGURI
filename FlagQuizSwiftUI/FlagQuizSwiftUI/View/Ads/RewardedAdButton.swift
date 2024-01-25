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
                    Text("rewardedAdButton.loading.description")
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
    
    private let adUnitID: String = "ca-app-pub-5402872764357733/9393019107"
    
    
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
        return
      }
        
      rewardedAd.present(fromRootViewController: viewController) {
        let reward = rewardedAd.adReward
        
        completion(reward.amount.intValue)
      }
    }
    
}

