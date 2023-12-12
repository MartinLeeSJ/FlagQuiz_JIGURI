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
    
    var body: some Scene {
        WindowGroup {
            AuthenticationRouterView(authViewModel: .init(container: container))
                .environmentObject(container)
        }
    }
}
