//
//  AuthenticationViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

final class AuthenticationViewModel: ObservableObject {
    private let contianer: DIContainer
    
    enum Action {
        case checkAuthenticationState
    }
    
    private var userId: String?
    
    init(contianer: DIContainer) {
        self.contianer = contianer
    }
    
    func send(_ action: Action) {
        switch action {
        case .checkAuthenticationState:
            if let userId = contianer.services.authService.checkAuthenticationState() {
                self.userId = userId
            }
        }
    }
    
    
}
