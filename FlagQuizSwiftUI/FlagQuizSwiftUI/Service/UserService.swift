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
}

class UserService: UserServiceType {
    private var repository: FQUserRepository
    
    init(repository: FQUserRepository) {
        self.repository = repository
    }
    
    func addUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        repository.addUser(user.toObject())
            .map { $0.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()   
    }
}

class StubUserService: UserServiceType {
    func addUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
