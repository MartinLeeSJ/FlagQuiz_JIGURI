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
    func getItems(ofUsers userId: String) -> AnyPublisher<[FQItemObject], DBError>
    func getItems(ofUsers userId: String) async throws -> [FQItemObject]
}

final class UserItemDBRepository: UserItemDBRepositoryType {
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        db.collection(CollectionKey.Items)
    }
    
    func getItems(ofUsers userId: String) -> AnyPublisher<[FQItemObject], DBError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getItems(ofUsers userId: String) async throws -> [FQItemObject] {
        []
    }

}
