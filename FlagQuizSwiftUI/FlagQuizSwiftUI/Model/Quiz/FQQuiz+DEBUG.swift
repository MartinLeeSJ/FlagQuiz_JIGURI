//
//  FQQuiz+DEBUG.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation

#if DEBUG
extension FQQuiz {
    // 예상되는 점수 4.5점
    static let mock4point5: FQQuiz = .init(
        quizCount: .five,
        quizOptionsCount: .five,
        quizType: .random,
        quizRounds: [
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseCaptialFromFlag
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("171"),
                quizOptionsCount: 5,
                quizType: .chooseCaptialFromFlag
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("172"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseNameFromFlag
            ),
        ]
    )
    
    static let mock1point5: FQQuiz = .init(
        quizCount: .five,
        quizOptionsCount: .five,
        quizType: .chooseFlagFromName,
        quizRounds: [
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("171"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("172"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
            .init(
                answerCountryCode: .init("170"),
                submittedCountryCode: .init("170"),
                quizOptionsCount: 5,
                quizType: .chooseFlagFromName
            ),
        ]
    )
    
}
#endif
