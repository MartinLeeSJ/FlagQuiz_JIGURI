//
//  UserItemDBRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol UserItemDBRepositoryType {
    func observeUserItems(of userId: String) -> AnyPublisher<[FQUserItemObject]?, DBError>
    func getUserItems(ofUser userId: String, ofType type: String) -> AnyPublisher<[FQUserItemObject], DBError>
    func getUserItems(ofUser userId: String, ofId itemIds: [String]) -> AnyPublisher<[FQUserItemObject], DBError>
    func addUserItems(of userId: String, items: [FQUserItemObject]) async throws
    func addUserItems(of userId: String, items: [FQUserItemObject]) -> AnyPublisher<Void, DBError>
    func deleteUserItem(of userId: String, deleting: FQUserItemObject) async throws
}

final class UserItemDBRepository: UserItemDBRepositoryType {
    private let db = Firestore.firestore()
    
    func observeUserItems(of userId: String) -> AnyPublisher<[FQUserItemObject]?, DBError> {
        collectionRef(ofUser: userId)
            .listenPublisher(FQUserItemObject.self)
            .mapError { DBError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func getUserItems(
        ofUser userId: String,
        ofType type: String
    ) -> AnyPublisher<[FQUserItemObject], DBError> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(DBError.invalidSelf))
                return
            }
            
            self.collectionRef(ofUser: userId)
                .whereField("itemTypeName", in: [type])
                .getDocuments { snapshot, error in
                    guard let snapshot else {
                        promise(.failure(DBError.fetchingError))
                        return
                    }
                    
                    if let error {
                        promise(.failure(DBError.custom(error)))
                        return
                    }
                    
                    do {
                        let data: [FQUserItemObject] = try snapshot.documents.map {
                            try $0.data(as: FQUserItemObject.self)
                        }
                        promise(.success(data))
                    } catch {
                        promise(.failure(DBError.decodingError))
                    }
                    
                }
        }
        .eraseToAnyPublisher()
        
    }
    
    func getUserItems(
        ofUser userId: String,
        ofId itemIds: [String]
    ) -> AnyPublisher<[FQUserItemObject], DBError> {
        
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(DBError.invalidSelf))
                return
            }
            
            self.collectionRef(ofUser: userId)
                .whereField(FieldPath.documentID(), in: itemIds)
                .getDocuments { snapshot, error in
                    guard error == nil else {
                        promise(.failure(DBError.custom(error!)))
                        return
                    }
                    guard let snapshot else {
                        promise(.failure(DBError.invalidObject))
                        return
                    }
                    
                    let data: [FQUserItemObject] = snapshot.documents.compactMap {
                        try? $0.data(as: FQUserItemObject.self)
                    }
                    
                    promise(.success(data))
                }
        }
        .eraseToAnyPublisher()
            
    }
    
    func addUserItems(
        of userId: String,
        items: [FQUserItemObject]
    ) async throws {
        let batch = db.batch()
        let collectionRef = collectionRef(ofUser: userId)
        
        for item in items {
            guard let itemId = item.itemId else { continue }
            
            do {
                try batch.setData(from: item.nilIdObject(), forDocument: collectionRef.document(itemId))
            } catch {
                throw DBError.batchError
            }
        }
        
        do {
            try await batch.commit()
        } catch {
            throw DBError.batchError
        }
    }
    
    func addUserItems(of userId: String, items: [FQUserItemObject]) -> AnyPublisher<Void, DBError> {
        let batch = db.batch()
        let collectionRef = collectionRef(ofUser: userId)
        
        return Future { promise in
            for item in items {
                guard let itemId = item.itemId else { continue }
                
                do {
                    try batch.setData(from: item.nilIdObject(), forDocument: collectionRef.document(itemId))
                } catch {
                    promise(.failure(DBError.batchError))
                }
            }
            
            batch.commit { error in
                if let error {
                    promise(.failure(DBError.custom(error)))
                    return
                }
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
        
    }
    
    func deleteUserItem(of userId: String, deleting item: FQUserItemObject) async throws {
        guard let id = item.itemId else {
            throw DBError.invalidObject
        }
        do {
            try await collectionRef(ofUser: userId)
                .document(id)
                .delete()
        } catch {
            throw DBError.custom(error)
        }
    }
    
    private func collectionRef(ofUser userId: String) -> CollectionReference {
        db.collection(CollectionKey.Users).document(userId).collection(CollectionKey.UserItem)
    }
}
