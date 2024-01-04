//
//  ItemDBRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol ItemDBRepositoryType {
    func getItems(of ids: [String]) -> AnyPublisher<[FQItemObject], DBError>
}

final class ItemDBRepository: ItemDBRepositoryType {
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        db.collection(CollectionKey.Items)
    }
    
    func getItems(of ids: [String]) -> AnyPublisher<[FQItemObject], DBError> {
        Empty().eraseToAnyPublisher()
    }
}
