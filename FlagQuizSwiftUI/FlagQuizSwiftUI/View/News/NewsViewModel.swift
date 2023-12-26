//
//  NewsViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation

@MainActor
final class NewsViewModel: ObservableObject {
    // user정보
    // 오늘의 국가정보
    @Published var quizStat: FQUserQuizStat? = nil
    @Published var countryQuizStat: FQCountryQuizStat? = nil
    
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
