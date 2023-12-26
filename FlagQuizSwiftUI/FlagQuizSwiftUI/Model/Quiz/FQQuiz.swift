//
//  FQQuiz.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation
import FirebaseFirestore

struct FQQuiz {
    let quizCount: Int
    let quizOptionsCount: Int
    
    var quizRounds: [FQQuizRound]
    private(set) var currentQuizIndex: Int = 0
    
    
    var currentQuizRound: FQQuizRound {
        quizRounds[currentQuizIndex]
    }
    
    var correctQuizRoundsCount: Int {
        quizRounds.filter { round in
            guard let submittedCountryCode = round.submittedCountryCode else {
                return false
            }
            
            return round.answerCountryCode == submittedCountryCode
        }.count
    }
    
    var correctQuizRoundsCountBeforeCurrentRound: Int {
        quizRounds[0..<currentQuizIndex].filter { round in
            guard let submittedCountryCode = round.submittedCountryCode else {
                return false
            }
            
            return round.answerCountryCode == submittedCountryCode
        }.count
    }
    
    var wrongQuizRoundsCountBeforeCurrentRound: Int {
        quizRounds[0..<currentQuizIndex].count - correctQuizRoundsCountBeforeCurrentRound
    }
    
    public func getQuizRoundResult() -> (correct: [FQCountryISOCode], wrong: [FQCountryISOCode]) {
        quizRounds.reduce(([FQCountryISOCode](), [FQCountryISOCode]())) { partial, currentRound in
            guard let submittedCountryCode = currentRound.submittedCountryCode else { return partial }
            
            if currentRound.answerCountryCode == submittedCountryCode {
                return (partial.0 + [currentRound.answerCountryCode], partial.1)
            }
            
            return (partial.0, partial.1 + [currentRound.answerCountryCode])
        }
    }
    
    mutating func toNextIndex() {
        guard currentQuizIndex < (quizCount - 1) else { return }
        currentQuizIndex += 1
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


extension FQQuiz {
    func toRecordObject() -> FQQuizRecordObject {
        .init(
            quizCount: quizCount,
            quizOptionsCount: quizOptionsCount,
            quizRounds: quizRounds.map { $0.toObject() },
            createdAt: .init(date: .now)
        )
    }
}

extension FQQuiz: Hashable { }
