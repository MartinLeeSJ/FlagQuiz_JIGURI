//
//  EarthCandyService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import Combine

protocol EarthCandyServiceType {
    
    func checkEarthCandyIsEnough(_ userId: String) -> AnyPublisher<Bool, ServiceError>
    func getCandyOrCreateIfNotExist(ofUser userId: String) -> AnyPublisher<FQEarthCandy?, ServiceError>
    func observeEarthCandy(ofUser userId: String) -> AnyPublisher<FQEarthCandy?, ServiceError>
    func updateCandy(_ model: FQEarthCandy, ofUser userId: String) -> AnyPublisher<Void, ServiceError>
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError>
    func deleteEarthCandy(ofUser userId: String) async throws
}

final class EarthCandyService: EarthCandyServiceType {
    private let repository: FQEarthCandyDBRepositoryType
    
    init(repository: FQEarthCandyDBRepositoryType) {
        self.repository = repository
    }
    
    func checkEarthCandyIsEnough(_ userId: String) -> AnyPublisher<Bool, ServiceError> {
        repository.getEarthCandy(ofUser: userId)
            .mapError {  ServiceError.custom($0) }
            .flatMap { object in
                guard let object else {
                    return Fail<Bool, ServiceError>(error: .invalid).eraseToAnyPublisher()
                }
                
                let isEnough: Bool = object.point >= FQEarthCandy.earthCandyPointForFeedingFrog
                
                return Just(isEnough).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func getCandyOrCreateIfNotExist(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        repository.getEarthCandy(ofUser: userId)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<FQEarthCandy?, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                if let object {
                    return Just(object.toModel()).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
                
                return repository.createEarthCandy(ofUser: userId)
                    .map { FQEarthCandy(userId: userId, point: 0)}
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func observeEarthCandy(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        repository.observeEarthCandy(ofUser: userId)
            .map { $0?.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func updateCandy(
        _ model: FQEarthCandy,
        ofUser userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        repository.updateEarthCandy(model.toObject(), ofUser: userId)
            .map { _ in }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
   
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError> {
        let candy = FQEarthCandy.earthCandyForFeedingFrog(ofUser: userId)
        return repository.updateEarthCandy(candy.toObject(), ofUser: userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteEarthCandy(ofUser userId: String) async throws {
        try await repository.deleteEarthCandy(ofUser: userId)
    }
    
}

final class StubEarthCandyService: EarthCandyServiceType {
    func checkEarthCandyIsEnough(_ userId: String) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getCandyOrCreateIfNotExist(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeEarthCandy(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        Just(FQEarthCandy(userId: "1", point: 10))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func updateCandy(
        _ model: FQEarthCandy,
        ofUser userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteEarthCandy(ofUser userId: String) async throws {}

}
