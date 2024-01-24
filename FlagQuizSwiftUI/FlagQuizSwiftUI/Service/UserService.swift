//
//  UserService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine

protocol UserServiceType {
    func getUser(ofId userId: String) -> AnyPublisher<FQUser, ServiceError>
    func getUser(ofId userId: String) async throws -> FQUser
    
    func addAnonymousUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError>
    func addUserIfNotExist(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError>
    
    func updateUser(of userId: String, model: FQUser) -> AnyPublisher<Void, ServiceError>
 
    func deleteUser(of userId: String) async throws
}

class UserService: UserServiceType {
    private var repository: FQUserRepository
    
    init(repository: FQUserRepository) {
        self.repository = repository
    }
    
    func getUser(ofId userId: String) -> AnyPublisher<FQUser, ServiceError> {
        repository.getUser(ofId: userId)
            .compactMap { $0?.toModel(withId: userId) }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func getUser(ofId userId: String) async throws -> FQUser {
        let user = try await repository.getUser(ofId: userId)
        return user.toModel(withId: userId)
    }
    
    func addAnonymousUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        repository.setUser(ofUser: user.id, object: user.toObject())
            .map { user }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func addUserIfNotExist(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        repository.getUser(ofId: user.id)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<FQUser,DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                if let object {
                    return Just(object.toModel(withId: user.id))
                        .setFailureType(to: DBError.self)
                        .eraseToAnyPublisher()
                }
                
                return self.repository.setUser(ofUser: user.id, object: user.toObject())
                    .map { user }
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
       
    }
    
    func deleteUser(of userId: String) async throws {
        try await repository.deleteUser(of: userId)
    }
    
    func updateUser(of userId: String, model: FQUser) -> AnyPublisher<Void, ServiceError> {
        repository.updateUser(of: userId, object: model.toObject())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
   
}

class StubUserService: UserServiceType {
    func getUser(ofId userId: String) -> AnyPublisher<FQUser, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getUser(ofId userId: String) async throws -> FQUser {
        .init(id: "1", createdAt: .now, userName: "martini")
    }
    
    func addAnonymousUser(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func addUserIfNotExist(_ user: FQUser) -> AnyPublisher<FQUser, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteUser(of userId: String) async throws {
        
    }
    
    func updateUser(of userId: String, model: FQUser) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
   
}
