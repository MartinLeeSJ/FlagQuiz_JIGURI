//
//  FQUserRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import Combine

import FirebaseFirestore

protocol FQUserRepositoryType {
    func addUser(_ user: FQUser) -> AnyPublisher<FQUserObject, DBError>
}

final class FQUserRepository: FQUserRepositoryType {
    private var db = Firestore.firestore()
    
    func addUser(_ user: FQUser) -> AnyPublisher<FQUserObject, DBError> {
        Future { [weak self] promise in
            do {
                try self?.db.collection(CollectionKey.Users).document(user.id).setData(from: user.toObject()){ error in
                    if let error {
                        promise(.failure(.custom(error)))
                    }
                }
                promise(.success(user.toObject()))
            } catch {
                promise(.failure(.custom(error)))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
}
