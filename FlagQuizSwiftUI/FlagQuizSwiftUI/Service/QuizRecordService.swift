//
//  QuizService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

protocol QuizRecordServiceType {
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws
}

final class QuizRecordService: QuizRecordServiceType {
    private let repository: FQQuizRecordRepositoryType
    
    init(repository: FQQuizRecordRepositoryType) {
        self.repository = repository
    }
    
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws {
        try repository.addQuizRecord(ofUser: userId, quiz.toRecordObject())
    }
}

final class StubQuizRecordService: QuizRecordServiceType {
    func addQuizRecord(ofUser userId: String, from quiz: FQQuiz) throws {
        
    }
}
