//
//  QuizService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import FirebaseFirestore

protocol QuizRecordServiceType {
    func getQuizRecords(
        ofUser userId: String,
        count limit: Int,
        startAt lastDocument: DocumentSnapshot?
    ) async throws -> (documents: [FQQuizRecord], lastDocument: DocumentSnapshot?)
    
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws
}

final class QuizRecordService: QuizRecordServiceType {
    private let repository: FQQuizRecordRepositoryType
    
    init(repository: FQQuizRecordRepositoryType) {
        self.repository = repository
    }

    func getQuizRecords(
        ofUser userId: String,
        count limit: Int,
        startAt lastDocument: DocumentSnapshot?
    ) async throws -> (documents: [FQQuizRecord], lastDocument: DocumentSnapshot?) {
        let (documents, lastDocument) = try await repository.getQuizRecords(ofUser: userId, count: limit, startAt: lastDocument)
        
        return (documents.map { $0.toModel() }, lastDocument)
        
    }
    
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws {
        try repository.addQuizRecord(ofUser: userId, quiz.toRecordObject())
    }
}

final class StubQuizRecordService: QuizRecordServiceType {
    func getQuizRecords(
        ofUser userId: String,
        count limit: Int,
        startAt lastDocument: DocumentSnapshot?
    ) async throws -> (documents: [FQQuizRecord], lastDocument: DocumentSnapshot?) {
        return ([], nil)
    }
    
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws {
        
    }
}
