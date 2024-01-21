//
//  NewsViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import SwiftUI

@MainActor
final class NewsViewModel: ObservableObject {
    
    @Published var quizStat: FQUserQuizStat?
    @Published var countryQuizStat: FQCountryQuizStat?
    
    
    private let container: DIContainer
    
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func load() async {
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        do {
            quizStat = try await container.services.quizStatService.getQuizStat(ofUser: userId)
            countryQuizStat = try await container.services.countryQuizStatService.getBestCountryQuizStat(of: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
}
