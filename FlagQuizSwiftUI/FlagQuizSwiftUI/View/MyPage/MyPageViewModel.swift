//
//  MyPageViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/11/24.
//

import Foundation
import Combine

@MainActor
final class MyPageViewModel: ObservableObject {
    @Published var user: FQUser?
    
    
    enum Action {
        case changeUserName
    }
    
    
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
    
    func updateUserName(to newUserName: String) {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        guard var updatingUser = user else { return }
        
        updatingUser.userName = newUserName
        
        container.services.userService.updateUser(of: userId, model: updatingUser)
            .sink { completion in
                if case .failure(let error) = completion {
                    //TODO: Error Handling
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    
    
}
