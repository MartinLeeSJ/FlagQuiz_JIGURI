//
//  MyPageViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/11/24.
//

import Foundation
import SwiftUI
import Combine



@MainActor
final class MyPageViewModel: ObservableObject {
    @Published var user: FQUser?
   
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func load() async {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        self.user = try? await container.services.userService.getUser(ofId: userId)
    }
    
    func isAnonymousUser() -> Bool? {
        container.services.authService.checkIfAnonymousUser()
    }
    
    func deleteAccount() async {
        guard let userId = user?.id else { return }
        do {
            try container.services.authService.signOut()
            try await container.services.userService.deleteUser(of: userId)
            try await container.services.earthCandyService.deleteEarthCandy(ofUser: userId)
            try await container.services.frogService.deleteFrog(ofUser: userId)
            _ = try await container.services.authService.deleteAccount()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}
