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
    @Published var presentsShouldLogOutAlert: Bool = false
    @Published var toast: ToastAlert?
    
    private let container: DIContainer
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    private var userId: String?
    private var nonce: String?
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case requestSignInWithApple(ASAuthorizationAppleIDRequest)
        case completeSignInWithApple(ASAuthorization)
        case signOut
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
            
            completeLinking(from: publisher)
        case .signOut:
            signOut()
        }
    }
    
    private func completeLinking(from publisher: AnyPublisher<FQUser, AuthenticationServiceError>) {
        linkingState = .linking
        
        publisher
            .flatMap { [weak self] user in
                guard let self else {
                    return Fail<FQUser, AuthenticationServiceError>(error: .invalidated).eraseToAnyPublisher()
                }
                
                return self.container.services.userService.updateUser(
                    of: user.id,
                    model: .init(
                        id: user.id,
                        createdAt: user.createdAt,
                        email: user.email,
                        userName: user.userName,
                        isAnonymous: false
                    )
                )
                .map { user }
                .mapError { AuthenticationServiceError.custom($0) }
                .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.linkingState = .failed
                    
                    switch error {
                    case .credentialAlreadyInUse:
                        self?.toast = .init(
                            style: .failed,
                            message: String(
                                localized: "toastAlert.linkingLogin.failed.already.In.Use",
                                defaultValue: "This Account Is Aleady In Use"
                            )
                        )
                        self?.presentsShouldLogOutAlert = true
                    default :
                        self?.toast = .init(
                            style: .failed,
                            message: String(
                                localized: "toastAlert.linkingLogin.failed",
                                defaultValue: "Failed to create an account"
                            )
                        )
                    }
                }
            } receiveValue: { [weak self] user in
                self?.userId = user.id
                self?.linkingState = .linked
            }
            .store(in: &cancellables)
    }
    
    private func signOut() {
        do {
            try container.services.authService.signOut()
            
        } catch {
            self.toast = .init(
                style: .failed,
                message: String(
                    localized: "toastAlert.linkingLogin.failed.to.signOut",
                    defaultValue: "Failed To Sign Out"
                )
            )
        }
    }
    
}

enum LinkingLoginState: Hashable {
    case unlinked
    case linking
    case linked
    case failed
}

