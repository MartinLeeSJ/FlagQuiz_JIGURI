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
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject, DBError>
    func getFrog(ofUser userId: String) async throws -> FQFrogObject
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, DBError>
    func updateFrog(_ object: FQFrogObject) -> AnyPublisher<Void, DBError>
    
}

final class FrogDBRepository: FrogDBRepositoryType {
    private let db = Firestore.firestore()
    private var collectionRef: CollectionReference {
        db.collection(CollectionKey.Frogs)
    }
    
    func getFrog(ofUser userId: String) -> AnyPublisher<FQFrogObject, DBError> {
        Future { [weak self] promise in
            self?.collectionRef.document(userId).getDocument(as: FQFrogObject.self) { result in
                switch result {
                case .success(let object):
                    promise(.success(object))
                case .failure(let error):
                    promise(.failure(error))
                }
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
    
    func addFrog(ofUser userId: String) -> AnyPublisher<Void, DBError> {
        let document: DocumentReference = collectionRef.document(userId)
        let object: FQFrogObject = .init(
            status: 0,
            lastUpdated: .init(date: .now),
            item: []
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
    
    func updateFrog(_ object: FQFrogObject) -> AnyPublisher<Void, DBError> {
        guard let id = object.id else {
            return Fail(
                outputType: Void.self,
                failure: DBError.invalidObject
            ).eraseToAnyPublisher()
        }
        
        let documentRef: DocumentReference = collectionRef.document(id)
        
        return Future { promise in
            do {
                try documentRef.setData(from: object)
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
    }
}
