//
//  FQCountryQuizStatRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation
import FirebaseFirestore

protocol FQCountryQuizStatRepositoryType {
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
    
    func getCountryQuizStats(of userId: String) async throws -> [FQCountryQuizStatObject] {
        let collectionRef = db.collection(CollectionKey.Users)
            .document(userId)
            .collection(CollectionKey.CountryQuizStats)
        
        var snapshots: QuerySnapshot
        
        do {
            snapshots = try await collectionRef.getDocuments()
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
    
    
    func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [String],
        substractingCodes substracting: [String]
    ) async throws {
        let batch = db.batch()
        
        let collectionRef = db.collection(CollectionKey.Users)
            .document(userId)
            .collection(CollectionKey.CountryQuizStats)
        
        adding.forEach {
            collectionRef.document($0).setData(["quizStat":  FieldValue.increment(Int64(1))])
        }
        
        substracting.forEach {
            collectionRef.document($0).setData(["quizStat":  FieldValue.increment(Int64(1))])
        }
        
        try await batch.commit()
    }
    
}
