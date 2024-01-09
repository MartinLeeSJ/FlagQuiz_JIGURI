//
//  FrogDBRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import Combine
import FirebaseFirestore

protocol FrogDBRepositoryType {
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject?, DBError>
    func getFrog(ofUser userId: String) async throws -> FQFrogObject
    func observeFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject?, DBError>
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, DBError>
    func updateFrog(_ object: FQFrogObject, ofUser userId: String) -> AnyPublisher<Void, DBError>
    
}

final class FrogDBRepository: FrogDBRepositoryType {
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        db.collection(CollectionKey.Frogs)
    }
    
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject?, DBError> {
        Future { [weak self] promise in
            self?.collectionRef.document(userId).getDocument(as: FQFrogObject?.self) { result in
                promise(result)
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
    
    func getFrog(ofUser userId: String) async throws -> FQFrogObject {
        try await collectionRef
            .document(userId)
            .getDocument(as: FQFrogObject.self)
    }
    
    func observeFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject?, DBError> {
        collectionRef.document(userId)
            .listenerPublisher(FQFrogObject?.self)
            .mapError { DBError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, DBError> {
        let document: DocumentReference = collectionRef.document(userId)
        let object: FQFrogObject = .init(
            status: 0,
            lastUpdated: .init(date: .now),
            items: []
        )
        
        return Future { promise in
            do {
                try document.setData(
                    from: object,
                    merge: false) { error in
                        if let error {
                            promise(.failure(error))
                            return
                        }
                        promise(.success(()))
                    }
            } catch {
                promise(.failure(error))
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
    
    func updateFrog(_ object: FQFrogObject, ofUser userId: String) -> AnyPublisher<Void, DBError> {
     
        let documentRef: DocumentReference = collectionRef.document(userId)

        return Future { promise in
            documentRef.updateData([
                "status": object.status,
                "lastUpdated": FieldValue.serverTimestamp(),
                "items": object.items
            ]) { error in
                if let error {
                    promise(.failure(error))
                    return
                }
                promise(.success(()))
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
}
