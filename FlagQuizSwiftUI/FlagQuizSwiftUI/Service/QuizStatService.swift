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
    
    func addQuizStat(ofUser userId: String, quiz: FQQuiz) async throws
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
    
    func addQuizStat(ofUser userId: String, quiz: FQQuiz) async throws {
        let capitalQuizResult = quiz.getQuizRoundResultCount(by: .chooseCaptialFromFlag)
        let flagToNameQuizResult = quiz.getQuizRoundResultCount(by: .chooseNameFromFlag)
        let nameToFlagQuizResult = quiz.getQuizRoundResultCount(by: .chooseFlagFromName)
        
        try await repository.addQuizStat(
            quizStat: .init(
                userId: userId,
                correctCountryQuizCount: quiz.correctQuizRoundsCount,
                countryQuizCount: quiz.quizCount,
                correctCaptialQuizCount: capitalQuizResult.correct,
                captialQuizCount: capitalQuizResult.total,
                correctFlagToNameQuizCount: flagToNameQuizResult.correct,
                flagToNameQuizCount: flagToNameQuizResult.total,
                correctNameToFlagQuizCount: nameToFlagQuizResult.correct,
                nameToFlagQuizCount: nameToFlagQuizResult.total
            )
        )
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
    
    func addQuizStat(ofUser userId: String, quiz: FQQuiz) async throws {
        
    }
}
