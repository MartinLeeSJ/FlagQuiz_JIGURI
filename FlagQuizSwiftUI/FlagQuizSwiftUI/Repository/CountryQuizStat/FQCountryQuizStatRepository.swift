//
//  FQCountryQuizStatRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation
import FirebaseFirestore

protocol FQCountryQuizStatRepositoryType {
    func getBestCountryQuizStat(
        of userId: String
    ) async throws -> FQCountryQuizStatObject?
    
    func getCountryQuizStats(
        of userId: String
    ) async throws -> [FQCountryQuizStatObject]
    
    func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [String],
        substractingCodes substracting: [String]
    ) async throws
}

final class FQCountryQuizStatRepository: FQCountryQuizStatRepositoryType {
    private let db = Firestore.firestore()
    
    public func getBestCountryQuizStat(
        of userId: String
    ) async throws -> FQCountryQuizStatObject? {
        let collectionRef = db.collection(CollectionKey.Users)
            .document(userId)
            .collection(CollectionKey.CountryQuizStats)
        
        let snapshots: QuerySnapshot = try await collectionRef.order(
            by: "quizStat",
            descending: true
        ).limit(to: 1).getDocuments()
        
        let objects: [FQCountryQuizStatObject] = try snapshots.documents.compactMap {
            try $0.data(as: FQCountryQuizStatObject.self)
        }
        
        return objects.first
    }
    
    public func getCountryQuizStats(of userId: String) async throws -> [FQCountryQuizStatObject] {
        let collectionRef = db.collection(CollectionKey.Users)
            .document(userId)
            .collection(CollectionKey.CountryQuizStats)
        
        var snapshots: QuerySnapshot
        
        do {
            snapshots = try await collectionRef.order(by: "quizStat", descending: true).getDocuments()
        } catch {
            throw DBError.fetchingError
        }
        
        do {
            let objects: [FQCountryQuizStatObject] = try snapshots.documents.compactMap {
                try $0.data(as: FQCountryQuizStatObject.self)
            }
            return objects
        } catch {
            throw DBError.decodingError
        }
    }
    
    
    public func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [String],
        substractingCodes substracting: [String]
    ) async throws {
        let batch = db.batch()
        
        let collectionRef = db.collection(CollectionKey.Users)
            .document(userId)
            .collection(CollectionKey.CountryQuizStats)
        
        adding.forEach {
            batch.setData(
                ["quizStat":  FieldValue.increment(Int64(1))],
                forDocument: collectionRef.document($0),
                merge: true
            )
            
        }
        
        substracting.forEach {
            batch.setData(
                ["quizStat":  FieldValue.increment(Int64(-1))],
                forDocument: collectionRef.document($0),
                merge: true
            )
        }
        
        try await batch.commit()
    }
    
}
