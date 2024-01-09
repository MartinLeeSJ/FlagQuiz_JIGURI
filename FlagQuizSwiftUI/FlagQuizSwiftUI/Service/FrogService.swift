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
    func feedFrog(_ model: FQFrog) -> AnyPublisher<FQFrog, ServiceError>
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
                
                return checkFrogStatus(object: object)
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    private func checkFrogStatus(object: FQFrogObject) -> AnyPublisher<FQFrog?, DBError> {
       
        var updatedObject: FQFrogObject = object
        let lastUpdated: Date = object.lastUpdated.dateValue()
        let calendar: Calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: lastUpdated, to: .now)
        
        guard let hours = components.hour, abs(hours) > 4 else {
            return Just(object.toModel()).setFailureType(to: DBError.self).eraseToAnyPublisher()
        }
        
        let newStatus: Int = updatedObject.status - Int(abs(hours) / 2)
        updatedObject.status = FrogState.safeValue(rawValue: newStatus).rawValue
        updatedObject.lastUpdated = .init(date: .now)
        
        return self.repository.updateFrog(updatedObject)
            .map { updatedObject.toModel() }
            .eraseToAnyPublisher()
    }
    
    func feedFrog(_ model: FQFrog) -> AnyPublisher<FQFrog, ServiceError> {
        guard model.state != .great else {
            return Fail<FQFrog, ServiceError>(error: .invalid).eraseToAnyPublisher()
        }
        var updatedModel: FQFrog = model
        updatedModel.state.upgrade()
        updatedModel.lastUpdated = .now
        
        return repository.updateFrog(updatedModel.toObject())
            .map { updatedModel }
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
        repository.updateFrog(model.toObject())
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
    
    func feedFrog(_ model: FQFrog) -> AnyPublisher<FQFrog, ServiceError> {
        var updatedModel = model
        updatedModel.state.upgrade()
        updatedModel.lastUpdated = .now
        
        return Just(updatedModel)
            .setFailureType(to: ServiceError.self)
            .eraseToAnyPublisher()
    }
    
    func addFrogIfNotExist(ofUser userId: String) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    func updateFrog(_ model: FQFrog) -> AnyPublisher<Void, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
