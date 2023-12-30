//
//  FlagQuizSwiftUIApp.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

@main
struct FlagQuizSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var container: DIContainer = .init(services: Services())
    @StateObject private var hapticsManager: HapticsManager = .init()
    @StateObject private var networkMonitor: NetworkMonitorManager = .init()
    @StateObject private var navigationModel: NavigationModel = .init()
    
    var body: some Scene {
        WindowGroup {
            AuthenticationRouterView(authViewModel: .init(container: container))
                .environmentObject(container)
                .environmentObject(hapticsManager)
                .environmentObject(networkMonitor)
                .environmentObject(navigationModel)
        }
    }
}
