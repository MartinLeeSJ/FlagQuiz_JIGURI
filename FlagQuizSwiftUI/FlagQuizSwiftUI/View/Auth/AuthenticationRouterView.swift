//
//  AuthenticationRouterView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct AuthenticationRouterView: View {
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var earthCandyModel: EarthCandyModel
    @EnvironmentObject private var hapticsManager: HapticsManager
    
    init(
        authViewModel: AuthenticationViewModel,
        earthCandyModel: EarthCandyModel
    ) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._earthCandyModel = StateObject(wrappedValue: earthCandyModel)
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
        .environmentObject(earthCandyModel)
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
        earthCandyModel: .init(container: .init(services: StubService()))
    )
    .environmentObject(HapticsManager())
}
