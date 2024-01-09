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
    
    public func observe() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.frogService.observeFrogWhileCheckingStatus(ofUser: userId)
            .sink { completion in
                if case .failure(let error) = completion {
                    
                }
            } receiveValue: { [weak self] frog in
                self?.frog = frog
            }
            .store(in: &cancellables)
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
        guard frog.state.rawValue < FrogState.great.rawValue else { return }
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.frogService.feedFrog(frog)
            .flatMap { [weak self] fed in
                guard let self else {
                    return Fail<Bool, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
                }
                
                guard fed else {
                    return Just(false).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                }
                
                return self.container.services.earthCandyService.useCandyForFeedingFrog(ofUser: userId)
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                //TODO: Error Handling
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
        
//        container.services.earthCandyService.useCandyForFeedingFrog(ofUser: userId)
//            .flatMap { [weak self] updated in
//                guard let self else {
//                    return Fail<Bool, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
//                }
//                
//                guard updated else {
//                    return Just(false).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
//                }
//                
//                return self.container.services.frogService.feedFrog(frog)
//                    .eraseToAnyPublisher()
//            }
//            .sink { _ in
//                //TODO: Error Handling
//            } receiveValue: { _ in
//                
//            }
//            .store(in: &cancellables)
    }
    
}
