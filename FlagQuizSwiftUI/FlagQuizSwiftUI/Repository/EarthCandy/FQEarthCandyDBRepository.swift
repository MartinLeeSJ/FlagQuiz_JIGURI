//
//  FQEarthCandyDBRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import Combine

import FirebaseFirestore

protocol FQEarthCandyDBRepositoryType {
    func createEarthCandy(ofUser userId: String) -> AnyPublisher<Void, DBError>
    func getEarthCandy(ofUser userId: String) -> AnyPublisher<FQEarthCandyObject?, DBError>
    func setEarthCandy(_ object: FQEarthCandyObject, ofUser userId: String) -> AnyPublisher<Void, DBError>
    func updateEarthCandy(_ object: FQEarthCandyObject, ofUser userId: String) -> AnyPublisher<Void, DBError>
}

final class FQEarthCandyDBRepository: FQEarthCandyDBRepositoryType {
    private let db = Firestore.firestore()
    private var candyCollection: CollectionReference {
        db.collection(CollectionKey.EarthCandy)
    }
    
    func createEarthCandy(ofUser userId: String) -> AnyPublisher<Void, DBError> {
        var newObject: FQEarthCandyObject = .init(point: 0)
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(DBError.invalidSelf))
                return
            }
            
            do {
                try self.candyCollection.document(userId).setData(from: newObject)
                promise(.success(()))
            } catch {
                promise(.failure(DBError.custom(error)))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getEarthCandy(ofUser userId: String) -> AnyPublisher<FQEarthCandyObject?, DBError> {
        let documentRef = candyCollection.document(userId)
        return Future {  promise in
            documentRef.getDocument(as: FQEarthCandyObject?.self) {
                promise($0)
            }
        }
        .mapError { DBError.custom($0) }
        .eraseToAnyPublisher()
        
    }
    
    func setEarthCandy(
        _ object: FQEarthCandyObject,
        ofUser userId: String
    ) -> AnyPublisher<Void, DBError> {
        let documentRef = candyCollection.document(userId)
        
        return Future {  promise in
            documentRef.setData([
                "point": FieldValue.increment(object.point)
            ]) { error in
                if let error {
                    promise(.failure(DBError.custom(error)))
                    return
                }
                
                promise(.success(()))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func updateEarthCandy(
        _ object: FQEarthCandyObject,
        ofUser userId: String
    ) -> AnyPublisher<Void, DBError> {
        let documentRef = candyCollection.document(userId)
        
        return Future {  promise in
            documentRef.updateData([
                "point": FieldValue.increment(object.point)
            ]) { error in
                if let error {
                    promise(.failure(DBError.custom(error)))
                    return
                }
                
                promise(.success(()))
            }
       
        }
        .eraseToAnyPublisher()
    }
}
