//
//  AuthenticationRouterView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct AuthenticationRouterView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var earthCandyViewModel: EarthCandyViewModel
    @EnvironmentObject private var hapticsManager: HapticsManager
    
    init(
        authViewModel: AuthenticationViewModel,
        earthCandyViewModel: EarthCandyViewModel
    ) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._earthCandyViewModel = StateObject(wrappedValue: earthCandyViewModel)
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
        .environmentObject(earthCandyViewModel)
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
        ),
        earthCandyViewModel: .init(container: .init(services: StubService()))
    )
    .environmentObject(HapticsManager())
}
