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
    func addUser(_ userObject: FQUserObject) -> AnyPublisher<FQUserObject, DBError>
}

final class FQUserRepository: FQUserRepositoryType {
    private var db = Firestore.firestore()
    
    func addUser(_ userObject: FQUserObject) -> AnyPublisher<FQUserObject, DBError> {
        Future { [weak self] promise in
            do {
                try self?.db.collection(CollectionKey.Users).addDocument(from: userObject) { error in
                    if let error {
                        promise(.failure(.custom(error)))
                    }
                }
                
                promise(.success(userObject))
                
            } catch {
                promise(.failure(.custom(error)))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
}
