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
    func getUser(ofId userId: String) -> AnyPublisher<FQUserObject?, DBError>
    func getUser(ofId userId: String) async throws -> FQUserObject
    
    func addUser(_ user: FQUser) -> AnyPublisher<FQUserObject, DBError>
    func deleteUser(of userId: String) -> AnyPublisher<Void, DBError>
    func setUser(ofUser userId: String, object: FQUserObject) -> AnyPublisher<Void, DBError>
    func updateUser(of userId: String, object: FQUserObject) -> AnyPublisher<Void, DBError>
}

final class FQUserRepository: FQUserRepositoryType {
    private let db = Firestore.firestore()
    private var usersCollection: CollectionReference {
        db.collection(CollectionKey.Users)
    }
    
    func getUser(ofId userId: String) -> AnyPublisher<FQUserObject?, DBError> {
        Future { [weak self] promise in
            self?.usersCollection.document(userId).getDocument(as: FQUserObject?.self) { result in
                promise(result)
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
    
    func getUser(ofId userId: String) async throws -> FQUserObject {
        try await usersCollection.document(userId).getDocument(as: FQUserObject.self)
    }
    
    func addUser(_ user: FQUser) -> AnyPublisher<FQUserObject, DBError> {
        Future { [weak self] promise in
            do {
                try self?.usersCollection.document(user.id).setData(from: user.toObject()){ error in
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
    
    func deleteUser(of userId: String) -> AnyPublisher<Void, DBError> {
        let userDocRef = db.collection(CollectionKey.Users).document(userId)
        
        return Future { promise in
            userDocRef.delete { error in
                if let error {
                    promise(.failure(DBError.custom(error)))
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func setUser(ofUser userId: String, object: FQUserObject) -> AnyPublisher<Void, DBError> {
        Future { [weak self] promise in
            do {
                try self?.usersCollection.document(userId).setData(from: object, mergeFields: [])
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
    
    func updateUser(of userId: String, object: FQUserObject) -> AnyPublisher<Void, DBError> {
        Future { [weak self] promise in
            do {
                try self?.usersCollection.document(userId)
                    .setData(from: object, mergeFields: ["email", "userName"])
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
            
    }
    
}
