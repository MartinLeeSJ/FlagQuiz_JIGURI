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
    func addUserItems(of userId: String, items: [FQUserItemObject]) async throws
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
