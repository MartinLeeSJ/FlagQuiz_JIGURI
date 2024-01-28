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
    func addItem(item: FQItemObject) throws
    func getItems() async throws -> [FQItemObject?]
    func updateItem(item: FQItemObject) throws
    func deleteItem(item: FQItemObject) async throws
}


final class StoreItemDBRepository: StoreItemDBRepositoryType {
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        db.collection(CollectionKey.Items)
    }
  
    func getItems() async throws -> [FQItemObject?] {
        try await collectionRef
            .whereField("isOnMarket", in: [true])
            .getDocuments(as: FQItemObject?.self)
    }
    
    func addItem(item: FQItemObject) throws {
        do {
            try collectionRef.addDocument(from: item)
        } catch {
            throw DBError.custom(error)
        }
    }
    
    func updateItem(item: FQItemObject) throws {
        guard let id = item.id else {
            throw DBError.invalidObject
        }
        do {
            try collectionRef.document(id).setData(from: item.nilIdObject())
        } catch {
            throw DBError.custom(error)
        }
    }
    
    func deleteItem(item: FQItemObject) async throws {
        guard let id = item.id else {
            throw DBError.invalidObject
        }
        
        do {
            try await collectionRef.document(id).delete()
        } catch {
            throw DBError.custom(error)
        }
    }
}


