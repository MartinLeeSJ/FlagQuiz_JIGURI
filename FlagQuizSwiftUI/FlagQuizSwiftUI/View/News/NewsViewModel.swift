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
    @Published var bestCountryQuizStat: FQCountryQuizStat?
    @Published var worstCountryQuizStat: FQCountryQuizStat?
    @Published var linkingLocation: LinkingLoginLocation?
    
    
    private let container: DIContainer
    
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func load() async {
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        do {
            quizStat = try await container.services.quizStatService.getQuizStat(ofUser: userId)
            bestCountryQuizStat = try await container.services.countryQuizStatService.getBestCountryQuizStat(of: userId)
            worstCountryQuizStat = try await container.services.countryQuizStatService.getWorstCountryQuizStat(of: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    public func isAnonymousUser() -> Bool? {
        container.services.authService.checkIfAnonymousUser()
    }
    
    public func setLinkingLocation(_ location: LinkingLoginLocation) {
        self.linkingLocation = location
    }
    
}
