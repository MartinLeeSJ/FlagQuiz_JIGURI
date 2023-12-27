//
//  CountryQuizStatViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import Foundation

@MainActor
final class CountryQuizStatViewModel: ObservableObject {
    @Published var stats: [FQCountryQuizStat] = []
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func load() async {
        #if DEBUG
        if container.services is StubService {
            do {
                stats = try await container.services.countryQuizStatService.getCountryQuizStats(of: "1")
            } catch {
                print(error.localizedDescription)
            }
            return
        }
        #endif
        
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        
        do {
            stats = try await container.services.countryQuizStatService.getCountryQuizStats(of: userId)
        } catch {
            print(error.localizedDescription)
        }
    }
}
