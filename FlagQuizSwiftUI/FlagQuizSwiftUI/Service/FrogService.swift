//
//  FrogService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import Combine

protocol FrogServiceType {
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError>
    func getFrog(ofUser userId: String) async throws -> FQFrog?
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, ServiceError>
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError>
}

final class FrogService: FrogServiceType {
    
    private let repository: FrogDBRepositoryType
    
    init(repository: FrogDBRepositoryType) {
        self.repository = repository
    }
    
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        repository.getFrog(ofUser: userId)
            .map { $0.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func getFrog(ofUser userId: String) async throws -> FQFrog? {
        let object = try await repository.getFrog(ofUser: userId)
        return object.toModel()
    }
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, ServiceError> {
        repository.addFrog(ofUser: userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        repository.updateFrog(model.toObject())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
}

final class StubFrogService: FrogServiceType {
    
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getFrog(ofUser userId: String) async throws -> FQFrog? {
        nil
    }
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
