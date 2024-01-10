//
//  FrogService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FrogServiceType {
    func getFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError>
    func observeFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError>
    
    func feedFrog(_ model: FQFrog) -> AnyPublisher<Bool, ServiceError>
    
    /// EarthCandy 사용이 실패했을 때 원래의 model로 다시 바꾸는 메서드
    /// - Parameter model: original FQFrog model
    /// - Returns: AnyPublisher<Void, ServiceError>
    func cancelFeedFrog(original model: FQFrog) -> AnyPublisher<Void, ServiceError>
    
    func addFrogIfNotExist(ofUser userId: String) -> AnyPublisher<Void, ServiceError>
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError>
}

final class FrogService: FrogServiceType {
    
    private let repository: FrogDBRepositoryType
    
    init(repository: FrogDBRepositoryType) {
        self.repository = repository
    }
    
    func getFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        repository.getFrog(ofUser: userId)
            .flatMap { [weak self] object -> AnyPublisher<FQFrog?, DBError> in
                guard let self else {
                    return Fail<FQFrog?, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                guard let object else {
                    return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
                
                return checkFrogStatus(object: object, ofUser: userId)
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func observeFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        repository.observeFrog(ofUser: userId)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<FQFrog?, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                return self.checkFrogStatus(object: object, ofUser: userId)
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
        
    }
    
    private func checkFrogStatus(object: FQFrogObject?, ofUser userId: String) -> AnyPublisher<FQFrog?, DBError> {
        guard var object: FQFrogObject = object else {
            return Just(nil).setFailureType(to: DBError.self).eraseToAnyPublisher()
        }
        
        let lastUpdated: Date = object.lastUpdated.dateValue()
        let calendar: Calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: lastUpdated, to: .now)
        
        guard let hours = components.hour, abs(hours) > 4 else {
            return Just(object.toModel()).setFailureType(to: DBError.self).eraseToAnyPublisher()
        }
        
        let newStatus: Int = object.status - Int(abs(hours) / 2)
        object.status = FrogState.safeValue(rawValue: newStatus).rawValue
        object.lastUpdated = .init(date: .now)
        
        return self.repository.updateFrog(object, ofUser: userId)
            .map { object.toModel() }
            .eraseToAnyPublisher()
    }
    
    func feedFrog(_ model: FQFrog) -> AnyPublisher<Bool, ServiceError> {
        guard model.state != .great else {
            return Just(false).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
        }
        var updatedModel: FQFrog = model
        updatedModel.state.upgrade()
        updatedModel.lastUpdated = .now
        
        return repository.updateFrog(updatedModel.toObject(), ofUser: model.userId)
            .map { true }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    
    func cancelFeedFrog(original model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        guard model.state != .great else {
            return Just(()).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
        }
        
        return repository.updateFrog(model.toObject(), ofUser: model.userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func addFrogIfNotExist(ofUser userId: String) -> AnyPublisher<Void, ServiceError> {
        repository.getFrog(ofUser: userId)
            .flatMap { [weak self] object in
                guard let self else {
                    return Fail<Void, DBError>(error: .invalidSelf).eraseToAnyPublisher()
                }
                
                guard object == nil else {
                    return Just(()).setFailureType(to: DBError.self).eraseToAnyPublisher()
                }
                
                return self.repository.addFrog(ofUser: userId)
                    .eraseToAnyPublisher()
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        repository.updateFrog(model.toObject(), ofUser: model.userId)
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
}

final class StubFrogService: FrogServiceType {
    func getFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        Just(FQFrog(userId: "1", state: .bad, lastUpdated: .now, items: []))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
        
    }
    
    func observeFrogWhileCheckingStatus(ofUser userId: String) -> AnyPublisher<FQFrog?, ServiceError> {
        Just(FQFrog(userId: "1", state: .bad, lastUpdated: .now, items: []))
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func feedFrog(_ model: FQFrog) -> AnyPublisher<Bool, ServiceError> {
        return Just(true)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func cancelFeedFrog(original model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func addFrogIfNotExist(ofUser userId: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
