//
//  AuthenticationRouterView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct AuthenticationRouterView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    
    init(authViewModel: AuthenticationViewModel) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                switch authViewModel.authState {
                case .unauthenticated:
                    LoginView()
                case .authenticating:
                    ProgressView()
                case .authenticated:
                    MainTabView()
                case .failed:
                    ErrorView {
                        authViewModel.send(.retry)
                    }
                }
            }
            .onAppear {
                authViewModel.send(.checkAuthenticationState)
            }
            .environmentObject(authViewModel)
        }
        
    }
}

#Preview {
    AuthenticationRouterView(
        authViewModel: AuthenticationViewModel(
            container: .init(services: StubService())
        )
    )
}
