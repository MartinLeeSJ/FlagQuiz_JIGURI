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
    
    
}
