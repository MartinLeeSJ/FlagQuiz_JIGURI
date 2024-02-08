//
//  FrogModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/8/24.
//

import Foundation
import Combine

enum FrogError: Error {
    case failedToObserve
    case failedToFeed
    case failedToCancelFeedFrog
    case failedToGetItems
    case notEnoughCandy
    case invalidSelf
    case custom(Error)
}

final class FrogModel: ObservableObject {
    @Published var frog: FQFrog?
    @Published var error: FrogError?
    @Published var items: [FQUserItem] = []
    
    private let container: DIContainer
    private let notificationManager: NotificationManager
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case feedFrog
    }
    
    init(container: DIContainer, notificationManager: NotificationManager) {
        self.container = container
        self.notificationManager = notificationManager
    }
    
    public func observe() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.frogService.observeFrogWhileCheckingStatus(ofUser: userId)
            .handleEvents(receiveOutput: { [weak self] frog in
                guard let strongSelf = self else { return }
                guard let frog else { return }
                Just(frog)
                    .last()
                    .flatMap { frog in
                        strongSelf.container.services.userItemService.getUserItems(ofUser: userId, itemIds: frog.items)
                            .eraseToAnyPublisher()
                    }
                    .sink { [weak self] completion in
                        if case .failure = completion {
                            self?.error = FrogError.failedToGetItems
                        }
                    } receiveValue: { [weak self] items in
                        self?.items = items
                    }
                    .store(in: &strongSelf.cancellables)
            })
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.error = FrogError.failedToObserve
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
        guard let currentFrog = frog else { return }
        guard currentFrog.state != .great else { return }
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        container.services.earthCandyService.checkEarthCandyIsEnough(
            userId,
            needed: FQEarthCandy.earthCandyPointForFeedingFrog
        )
            .mapError { FrogError.custom($0) }
            .flatMap { [weak self] isEnough in
                guard let self else {
                    return Fail<Bool, FrogError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                guard isEnough else {
                    return Fail<Bool, FrogError>(error: .notEnoughCandy).eraseToAnyPublisher()
                }
                
                return feed(frog: currentFrog, ofUser: userId)
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                }
            } receiveValue: { [weak self] success in
                if success {
                    var updatedFrog = currentFrog
                    updatedFrog.state.upgrade()
                    
                    self?.notificationManager.addFrogStateNotification(when: updatedFrog.state)
                }
                
            }
            .store(in: &cancellables)
    }
    
    
    private func feed(frog: FQFrog, ofUser userId: String) -> AnyPublisher<Bool, FrogError> {
        container.services.frogService.feedFrog(frog)
            .mapError { FrogError.custom($0) }
            .flatMap { [weak self] fed -> AnyPublisher<Bool, FrogError> in
                guard let self else {
                    return Fail<Bool, FrogError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                guard fed else {
                    return Fail<Bool, FrogError>(error: .failedToFeed).eraseToAnyPublisher()
                }
                
                return self.useCandyForFeeding(frog: frog, ofUser: userId)
            }
            .eraseToAnyPublisher()
    }
    
    private func useCandyForFeeding(
        frog: FQFrog,
        ofUser userId: String
    ) -> AnyPublisher<Bool, FrogError> {
      container.services.earthCandyService.useCandyForFeedingFrog(ofUser: userId)
            .flatMap { isUpdated  in
                if isUpdated {
                    return Just(true).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                }
                
                return self.container.services.frogService.cancelFeedFrog(original: frog)
                    .map { true }
                    .eraseToAnyPublisher()
                
            }
            .mapError{ _ in FrogError.failedToCancelFeedFrog }
            .eraseToAnyPublisher()
    }
    
    
}
