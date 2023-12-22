//
//  UserService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine

protocol UserServiceType {
    func addUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError>
    func deleteUser(of userId: String) -> AnyPublisher<Void, ServiceError>
}

class UserService: UserServiceType {
    private var repository: FQUserRepository
    
    init(repository: FQUserRepository) {
        self.repository = repository
    }
    
    func addUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        repository.addUser(user)
            .compactMap { $0.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()   
    }
    
    func deleteUser(of userId: String) -> AnyPublisher<Void, ServiceError> {
        repository.deleteUser(of: userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
}

class StubUserService: UserServiceType {
    func addUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteUser(of userId: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
