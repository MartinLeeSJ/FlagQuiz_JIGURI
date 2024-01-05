//
//  EarthCandyViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import Combine

class EarthCandyViewModel: ObservableObject {
    @Published var earthCandy: FQEarthCandy?
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    @MainActor
    public func load() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.earthCandyService.getCandyOrCreateIfNotExist(ofUser: userId)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] earthCandy in
                self?.earthCandy = earthCandy
            }
            .store(in: &cancellables)
    }
    
}
