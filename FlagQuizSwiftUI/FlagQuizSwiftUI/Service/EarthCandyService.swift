//
//  EarthCandyService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import Combine

protocol EarthCandyServiceType {
    func checkEarthCandyIsEnough(_ userId: String, needed amount: Int) -> AnyPublisher<Bool, ServiceError>
    func observeEarthCandy(ofUser userId: String) -> AnyPublisher<FQEarthCandy?, ServiceError>
    func updateCandy(_ point: Int, ofUser userId: String) -> AnyPublisher<Void, ServiceError>
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError>
    func deleteEarthCandy(ofUser userId: String) async throws
    
    func getEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError>
    
    func observeEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError>
    
    func recordEarthCandyRewardRecord(
        _ model: FQEarthCandyRewardRecord,
        userId: String
    ) -> AnyPublisher<Void, ServiceError>
}

final class EarthCandyService: EarthCandyServiceType {
    private let repository: FQEarthCandyDBRepositoryType
    
    init(repository: FQEarthCandyDBRepositoryType) {
        self.repository = repository
    }
    
    func checkEarthCandyIsEnough(_ userId: String, needed amount: Int) -> AnyPublisher<Bool, ServiceError> {
        repository.getEarthCandy(ofUser: userId)
            .mapError {  ServiceError.custom($0) }
            .flatMap { object in
                guard let object else {
                    return Fail<Bool, ServiceError>(error: .invalid).eraseToAnyPublisher()
                }
                
                let isEnough: Bool = object.point >= amount
                
                return Just(isEnough).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
            }
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
        _ point: Int,
        ofUser userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        repository.getEarthCandy(ofUser: userId)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<Void, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                if object == nil {
                    return self.repository.createEarthCandy(ofUser: userId, candyCount: point).eraseToAnyPublisher()
                }
                
                return self.repository.updateEarthCandyPoint(point, ofUser: userId)
                    .map { _ in }
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
   
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError> {
        let candy = FQEarthCandy.earthCandyForFeedingFrog(ofUser: userId)
        return repository.updateEarthCandyPoint(candy.point, ofUser: userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func deleteEarthCandy(ofUser userId: String) async throws {
        try await repository.deleteEarthCandy(ofUser: userId)
    }
    
    func getEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError> {
        repository.getEarthCandyRewardRecord(ofUser: userId)
            .map { $0?.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    
    func observeEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError> {
        repository.observeEarthCandyRewardRecord(ofUser: userId)
            .map { $0?.toModel() }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func recordEarthCandyRewardRecord(
        _ model: FQEarthCandyRewardRecord,
        userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        repository.recordEarthCandyRewardRecord(
            model.toObject(),
            userId: userId
        )
        .mapError { ServiceError.custom($0) }
        .eraseToAnyPublisher()
    }
    
}

final class StubEarthCandyService: EarthCandyServiceType {
    func checkEarthCandyIsEnough(_ userId: String, needed amount: Int) -> AnyPublisher<Bool, ServiceError> {
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
        _ point: Int,
        ofUser userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func useCandyForFeedingFrog(ofUser userId: String) -> AnyPublisher<Bool, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func deleteEarthCandy(ofUser userId: String) async throws {}
    
    func getEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    
    func observeEarthCandyRewardRecord(
        ofUser userId: String
    ) -> AnyPublisher<FQEarthCandyRewardRecord?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func recordEarthCandyRewardRecord(
        _ model: FQEarthCandyRewardRecord,
        userId: String
    ) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }

}
