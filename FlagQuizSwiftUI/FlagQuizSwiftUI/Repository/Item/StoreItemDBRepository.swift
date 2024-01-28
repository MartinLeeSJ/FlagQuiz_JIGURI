//
//  StoreItemDBRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import Combine

import FirebaseFirestore

protocol StoreItemDBRepositoryType {
    
}


final class StoreItemDBRepository: StoreItemDBRepositoryType {
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


