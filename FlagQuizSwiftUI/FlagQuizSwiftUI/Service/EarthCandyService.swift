//
//  EarthCandyService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import Combine

protocol EarthCandyServiceType {
    func getCandyOrCreateIfNotExist(ofUser userId: String) -> AnyPublisher<FQEarthCandy?, ServiceError>
    func observeEarthCandy(ofUser userId: String) -> AnyPublisher<FQEarthCandy?, ServiceError>
    func updateCandy(_ model: FQEarthCandy, ofUser userId: String) -> AnyPublisher<Void, ServiceError>
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError>
}

final class EarthCandyService: EarthCandyServiceType {
    private let repository: FQEarthCandyDBRepositoryType
    
    init(repository: FQEarthCandyDBRepositoryType) {
        self.repository = repository
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
    
    ///  FrogState 의 상태를 업그레이드할 때 필요한 EarthCandy의 값만큼 빼서 데이터베이스에 반영하는 메서드
    /// - Parameter userId: 유저 ID
    /// - Returns: Output -> 성공여부, Failure -> ServiceError
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError> {
        let candy = FQEarthCandy.earthCandyForFeedingFrog(ofUser: userId)
        return repository.getEarthCandy(ofUser: userId)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<Bool, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                guard let object else {
                    return Fail<Bool, DBError>(error: .invalidObject).eraseToAnyPublisher()
                }
                
                guard object.point >= abs(candy.point) else {
                    return Just(false).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
                
                return self.repository.updateEarthCandy(candy.toObject(), ofUser: userId)
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
}

final class StubEarthCandyService: EarthCandyServiceType {
    
    func getCandyOrCreateIfNotExist(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func observeEarthCandy(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandy?, ServiceError> {
        Empty().eraseToAnyPublisher()
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

}
