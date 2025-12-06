//
//  FQMarathon.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/6/25.
//

import Foundation

struct FQMarathon {
    let quizOptionsCount: FQQuizOptionsCount
    let quizType: FQQuizType
    var quizRounds: [FQQuizRound]
    private(set) var currentQuizIndex: Int = .zero
    
    
    init(
        quizType: FQQuizType,
        quizOptionsCount: FQQuizOptionsCount
    ) {
        self.quizType = quizType
        self.quizOptionsCount = quizOptionsCount
        self.quizRounds = Self.createQuizRounds(
            quizOptionsCount: quizOptionsCount.rawValue,
            quizType: quizType
        )
        
    }
    
    var currentQuizRound: FQQuizRound {
        quizRounds[currentQuizIndex]
    }
    
    mutating func toNextIndex() {
        guard currentQuizIndex < FQCountryISOCode.safeAllCodesCount - 1 else { return }
        currentQuizIndex += 1
    }
    
    
    
    static private func createQuizRounds(quizOptionsCount: Int, quizType: FQQuizType) -> [FQQuizRound] {
        FQCountryISOCode.safeAllCodes.shuffled().map {
            FQQuizRound(answerCountryCode: $0, quizOptionsCount: quizOptionsCount, quizType: quizType)
        }
    }
}
