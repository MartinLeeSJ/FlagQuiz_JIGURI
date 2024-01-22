//
//  UserRankViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/2/24.
//

import Foundation
import Combine

@MainActor
final class UserRankViewModel: ObservableObject {
    @Published var userQuizStat: FQUserQuizStat?
    @Published var toast: ToastAlert?
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func loadUserQuizStat() async {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            toast = ToastAlert(
                style: .failed,
                message: String(
                    localized: "toastAlert.invalid.user",
                    defaultValue: "Invalid User"
                )
            )
            return
        }
        
        
        do {
            if let userQuizStat = try await container.services.quizStatService.getQuizStat(ofUser: userId) {
                self.userQuizStat = userQuizStat
            } else {
                toast = .init(
                    style: .failed,
                    message: String(
                        localized: "toastAlert.userQuizStat.nilData",
                        defaultValue: "You have to do a quiz first"
                    )
                )
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
  
    
}
