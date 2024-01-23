//
//  LinkingLoginViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/23/24.
//

import Foundation
import Combine
import AuthenticationServices

class LinkingLoginViewModel: ObservableObject {
    @Published var linkingState: LinkingLoginState = .unlinked
    @Published var toast: ToastAlert?
    
    private let container: DIContainer
    let location: LinkingLoginLocation
    
    init(
        container: DIContainer,
        location: LinkingLoginLocation
    ) {
        self.container = container
        self.location = location
    }
    
    private var userId: String?
    private var nonce: String?
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case requestSignInWithApple(ASAuthorizationAppleIDRequest)
        case completeSignInWithApple(ASAuthorization)
    }
    
    func send(_ action: Action) {
        switch action {
        case .requestSignInWithApple(let request):
            let nonce = container.services.authService.requestSignInWithApple(request)
            self.nonce = nonce
            
        case .completeSignInWithApple(let authorization):
            guard let nonce else { return }
            let publisher =
            container.services.authService.completeSignWithApple(
                authorization,
                isLinking: true,
                nonce: nonce
            )
            
            completeAuthentication(from: publisher)
        }
    }
    
    private func completeAuthentication(from publisher: AnyPublisher<FQUser, AuthenticationServiceError>) {
        linkingState = .linking
        
        publisher
            .mapError { ServiceError.custom($0) }
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.linkingState = .failed
                    self?.toast = .init(
                        style: .failed,
                        message: String(
                            localized: "toastAlert.linkingLogin.failed",
                            defaultValue: "Failed to create an account"
                        )
                    )
                }
            } receiveValue: { [weak self] user in
                self?.userId = user.id
                self?.linkingState = .linked
            }
            .store(in: &cancellables)
    }
    
}

enum LinkingLoginState: Hashable {
    case unlinked
    case linking
    case linked
    case failed
}

enum LinkingLoginLocation {
    case mypage
    case reward
    case frogStateButton
    case userRank
    case countryStat
    case userStat
    case store
    case closet
    
    var description: String {
        switch self {
        case .mypage:
            String(
                localized: "linkingLogin.mypage.description",
                defaultValue: "To access more features,\nplease create an account now."
            )
        case .reward:
            String(
                localized: "linkingLogin.reward.description",
                defaultValue: "To receive EarthCandy rewards,\nplease create an account now."
            )
        case .frogStateButton:
            String(
                localized: "linkingLogin.frogStateButton.description",
                defaultValue: "To make the frog happy,\nplease create an account now."
            )
        case .userRank:
            String(
                localized: "linkingLogin.userRank.description",
                defaultValue: "If you want to see your detailed rank,\nplease create an account now."
            )
        case .countryStat:
            String(
                localized: "linkingLogin.countryStat.description",
                defaultValue: "If you'd like to see your country stats, \n please create an account now."
            )
        case .userStat:
            String(
                localized: "linkingLogin.userStat.description",
                defaultValue: "If you'd like to see your quiz record, \n please create an account now."
            )
        case .store:
            String(
                localized: "linkingLogin.store.description",
                defaultValue: "To access the store,\nplease create an account now."
            )
        case .closet:
            String(
                localized: "linkingLogin.closet.description",
                defaultValue: "To access the closet,\nplease create an account now."
            )
        }
    }
    
}
