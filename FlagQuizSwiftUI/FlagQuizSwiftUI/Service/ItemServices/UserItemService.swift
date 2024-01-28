//
//  UserItemService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import Combine

protocol UserItemServiceType {
    func observeUserItems(of userId: String) -> AnyPublisher<[FQUserItem], ServiceError>
    func addUserItems(of userId: String, items: [FQUserItem]) async throws
    func deleteUserItem(of userId: String, deleting: FQUserItem) async throws
}

final class UserItemService: UserItemServiceType {
    private let repository: UserItemDBRepositoryType
    
    init(repository: UserItemDBRepositoryType) {
        self.repository = repository
    }
    
    func observeUserItems(of userId: String) -> AnyPublisher<[FQUserItem], ServiceError> {
        repository.observeUserItems(of: userId)
            .mapError { ServiceError.custom($0) }
            .flatMap { object in
                guard let object else {
                    return Just([FQUserItem]()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                }
                
                return Just(object.compactMap { $0.toModel() })
                    .setFailureType(to: ServiceError.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func addUserItems(of userId: String, items: [FQUserItem]) async throws {
        try await repository.addUserItems(of: userId, items: items.map { $0.toObject() })
    }
    func deleteUserItem(of userId: String, deleting: FQUserItem) async throws {
        try await repository.deleteUserItem(of: userId, deleting: deleting.toObject())
    }
}

final class StubUserItemService: UserItemServiceType {
    func observeUserItems(of userId: String) -> AnyPublisher<[FQUserItem], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    func addUserItems(of userId: String, items: [FQUserItem]) async throws {}
    func deleteUserItem(of userId: String, deleting: FQUserItem) async throws {}
}
