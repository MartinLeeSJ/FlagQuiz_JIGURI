//
//  CreateUserNameViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/15/24.
//

import Foundation
import Combine

final class CreateUserNameViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var didCreatedUserName: Bool = false
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    
    func createUserName() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        
        container.services.userService.updateUser(
            of: userId,
            model: .init(id: "", createdAt: .now, userName: userName)
        )
        .sink { [weak self] completion in
            if case .finished = completion {
                self?.didCreatedUserName = true
            }
        } receiveValue: { _ in
            
        }
        .store(in: &cancellables)
        
    }
}
