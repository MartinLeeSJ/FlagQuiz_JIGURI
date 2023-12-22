//
//  QuizStatService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import Combine

protocol QuizStatServiceType {
    
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStat
    
    func addQuizStat(ofUser userId: String,
                     addingQuizCount quizCount: Int,
                     addingCorrectQuizCount correctCount: Int) async throws
}

final class QuizStatService: QuizStatServiceType {
    private let repository: FQUserQuizStatRepositoryType
    
    init(repository: FQUserQuizStatRepositoryType) {
        self.repository = repository
    }
    
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStat {
        let object = try await repository.getQuizStat(ofUser: userId)
        
        guard let model = object.toModel() else {
            throw ServiceError.failedToConvertObjectIntoModel
        }
        
        return model
    }
    
    func addQuizStat(ofUser userId: String,
                     addingQuizCount quizCount: Int,
                     addingCorrectQuizCount correctCount: Int) async throws {
        try await repository.addQuizStat(ofUser: userId,
                                         addingQuizCount: quizCount,
                                         addingCorrectQuizCount: correctCount)
    }
}

final class StubQuizStatService: QuizStatServiceType {
    func getQuizStat(ofUser userId: String) async throws -> FQUserQuizStat {
        .init(userId: "1",
              correctCountryQuizCount: 100,
              countryQuizCount: 120,
              correctCaptialQuizCount: 80,
              captialQuizCount: 100
        )
    }
    
    func addQuizStat(ofUser userId: String,
                     addingQuizCount quizCount: Int,
                     addingCorrectQuizCount correctCount: Int) async throws {
        
    }
}
