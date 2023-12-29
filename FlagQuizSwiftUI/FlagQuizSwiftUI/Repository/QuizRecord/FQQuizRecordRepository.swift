//
//  FQQuizRecordRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import FirebaseFirestore

protocol FQQuizRecordRepositoryType {
    func getQuizRecords(
        ofUser userId: String,
        count limit: Int,
        startAt lastDocument: DocumentSnapshot?
    ) async throws -> (documents: [FQQuizRecordObject], lastDocument: DocumentSnapshot?)
    
    func addQuizRecord(ofUser userId: String, _ record: FQQuizRecordObject) throws
}

final class FQQuizRecordRepository: FQQuizRecordRepositoryType {
    private let db = Firestore.firestore()
    
    func addQuizRecord(ofUser userId: String, _ record: FQQuizRecordObject) throws {
        let collectionRef = db.collection(CollectionKey.Users)
                       .document(userId)
                       .collection(CollectionKey.QuizRecord)
                    
        try collectionRef.addDocument(from: record)
    }
    
    func getQuizRecords(
        ofUser userId: String,
        count limit: Int,
        startAt lastDocument: DocumentSnapshot?
    ) async throws -> (documents: [FQQuizRecordObject], lastDocument: DocumentSnapshot?) {
        let query: Query = db.collection(CollectionKey.Users)
                       .document(userId)
                       .collection(CollectionKey.QuizRecord)
                       .order(by: "createdAt", descending: true)
                       .limit(to: limit)

        if let lastDocument {
            return try await query.start(afterDocument: lastDocument)
                                  .getDocumentsWithSnapshot(as: FQQuizRecordObject.self)
        } else {
            return try await query.getDocumentsWithSnapshot(as: FQQuizRecordObject.self)
        }
    }
    
}
