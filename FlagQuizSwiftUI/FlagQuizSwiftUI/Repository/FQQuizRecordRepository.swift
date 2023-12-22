//
//  FQQuizRecordRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import FirebaseFirestore

protocol FQQuizRecordRepositoryType {
    func addQuizRecord(ofUser userId: String, _ record: FQQuizRecordObject) throws
}

final class FQQuizRecordRepository: FQQuizRecordRepositoryType {
    private let db = Firestore.firestore()
    
    func addQuizRecord(ofUser userId: String, _ record: FQQuizRecordObject) throws {
        let docRef = db.collection(CollectionKey.Users)
                       .document(userId)
                       .collection(CollectionKey.QuizRecord)
                    
        try docRef.addDocument(from: record)
    }
}
