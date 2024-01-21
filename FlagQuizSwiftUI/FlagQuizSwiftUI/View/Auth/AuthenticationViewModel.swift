//
//  AuthenticationViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine
import AuthenticationServices

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
    case failed(Error)
}

final class AuthenticationViewModel: ObservableObject {
    enum Action {
        case checkAuthenticationState
//        case signInWithGoogle
        case requestSignInWithApple(ASAuthorizationAppleIDRequest)
        case completeSignInWithApple(ASAuthorization)
        case retry
        case signOut
    }
    
    @Published var authState: AuthenticationState = .unauthenticated
    
    private let container: DIContainer
    
    private var userId: String?
    private var nonce: String?
    private var subscription = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = container.services.authService.checkAuthenticationState() {
                self.userId = userId
                self.authState = .authenticated
            }
//        case .signInWithGoogle:
//            let publisher = container.services.authService.signInWithGoogle()
//            completeAuthentication(from: publisher)
            
        case .requestSignInWithApple(let request):
            let nonce = container.services.authService.requestSignInWithApple(request)
            self.nonce = nonce
            
        case .completeSignInWithApple(let authorization):
            guard let nonce else { return }
            let publisher = container.services.authService.completeSignInWithApple(authorization, nonce: nonce)
            completeAuthentication(from: publisher)
        case .retry:
            authState = .unauthenticated
        case .signOut:
            do {
                try container.services.authService.signOut()
                authState = .unauthenticated
            } catch {
                authState = .failed(error)
                print(error.localizedDescription)
            }
        }
    }
    
    
    private func completeAuthentication(from publisher: AnyPublisher<FQUser, AuthenticationServiceError>) {
        authState = .authenticating
        
        publisher
            .mapError { ServiceError.custom($0) }
            .flatMap { [weak self] user in
                guard let self else {
                    return Fail(outputType: FQUser.self, failure: ServiceError.nilSelf).eraseToAnyPublisher()
                }
                return self.container.services.userService.addUserIfNotExist(user)
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.authState = .failed(error)
                }
            } receiveValue: { [weak self] user in
                self?.userId = user.id
                self?.authState = .authenticated
            }
            .store(in: &subscription)
    }
}
