//
//  FrogViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/8/24.
//

import Foundation
import Combine

final class FrogViewModel: ObservableObject {
    @Published var frog: FQFrog?
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case feedFrog
    }
    
    init(container: DIContainer) {
        self.container = container
    }
    
    
    public func load() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.frogService.getFrogWhileCheckingStatus(ofUser: userId)
            .sink { completion in
                if case .failure(let error) = completion {
                    
                }
            } receiveValue: { [weak self] frog in
                self?.frog = frog
            }
            .store(in: &cancellables)
    }
    
    public func send(_ action: Action) {
        switch action {
        case .feedFrog:
            feedFrog()
        }
    }
    
    private func feedFrog() {
        guard let frog else { return }
        guard frog.status.rawValue < FrogState.great.rawValue else { return }
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.earthCandyService.useCandyForFeedingFrog(ofUser: userId)
            .flatMap { [weak self] _ in
                guard let self else {
                    return Fail<FQFrog, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
                }
                return self.container.services.frogService.feedFrog(frog)
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                //TODO: Error Handling
            } receiveValue: { [weak self] frog in
                self?.frog = frog
            }
            .store(in: &cancellables)
    }
    
}
