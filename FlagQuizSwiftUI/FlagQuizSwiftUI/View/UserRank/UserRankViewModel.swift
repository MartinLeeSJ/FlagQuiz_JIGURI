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
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func loadUserQuizStat() async {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        do {
            self.userQuizStat = try await container.services.quizStatService.getQuizStat(ofUser: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
  
    
}
