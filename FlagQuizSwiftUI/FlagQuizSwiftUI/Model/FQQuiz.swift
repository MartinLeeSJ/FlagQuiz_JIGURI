//
//  FQQuiz.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation

struct FQQuiz {
    let quizCount: Int
    let quizOptionsCount: Int
    
    var quizRounds: [FQQuizRound]
    private(set) var currentQuizIndex: Int = 0
    var currentQuizRound: FQQuizRound {
        quizRounds[currentQuizIndex]
    }
    
    mutating func toNextIndex() -> Bool {
        guard currentQuizIndex < (quizCount - 1) else { return false }
        currentQuizIndex += 1
        return true
    }
    
    init(quizCount: Int, quizOptionsCount: Int) {
        self.quizCount = quizCount
        self.quizOptionsCount = quizOptionsCount
        self.quizRounds = Self.createQuizRounds(quizCount: quizCount, quizOptionsCount: quizOptionsCount)
    }

    static private func createQuizRounds(quizCount: Int, quizOptionsCount: Int) -> [FQQuizRound] {
        FQCountryISOCode.chooseRandomly(quizCount, except: nil).map {
            FQQuizRound(answerCountryCode: $0, quizOptionsCount: quizOptionsCount)
        }
    }
}
