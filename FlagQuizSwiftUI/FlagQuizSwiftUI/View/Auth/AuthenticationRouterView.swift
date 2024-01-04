//
//  AuthenticationRouterView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct AuthenticationRouterView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var hapticsManager: HapticsManager
    
    init(authViewModel: AuthenticationViewModel) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
    }
    
    var body: some View {
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
        .environmentObject(authViewModel)
        .onAppear {
            authViewModel.send(.checkAuthenticationState)
            hapticsManager.send(.prepare)
        }
    }
}

#Preview {
    AuthenticationRouterView(
        authViewModel: AuthenticationViewModel(
            container: .init(services: StubService())
        )
    )
    .environmentObject(HapticsManager())
}
