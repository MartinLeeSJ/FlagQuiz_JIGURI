//
//  EditUserNameViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/12/24.
//

import SwiftUI
import Combine




final class EditUserNameViewModel: ObservableObject {
    @AppStorage("userNameUpdateRecord") private var userNameUpdateRecord = UserNameUpdateRecord()
    @Published var userName: String = ""
    @Published var isAlertOn: Bool = false
    
    public var editUserNameError: EditUserNameError?
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func updateUserName(user: FQUser?, _ completion: @escaping () -> Void) {
        guard userNameUpdateRecord.canUpdate() else {
            alert(error: .endOfTrial)
            return
        }
        guard let userId = container.services.authService.checkAuthenticationState() else {
            alert(error: .invalidRequest)
            return
        }
        guard var updatingUser = user else {
            alert(error: .invalidRequest)
            return
        }
        
        updatingUser.userName = userName
        
        container.services.userService.updateUser(of: userId, model: updatingUser)
            .sink { [weak self] result in
                switch result {
                case .finished: completion()
                case .failure: self?.alert(error: .failedToUpdate)
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    private func alert(error: EditUserNameError) {
        isAlertOn = true
        editUserNameError = error
    }
    
}
