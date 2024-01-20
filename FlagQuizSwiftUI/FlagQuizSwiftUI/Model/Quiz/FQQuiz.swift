//
//  FQQuiz.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation
import FirebaseFirestore

struct FQQuiz {
    let quizCount: FQQuizCount
    let quizOptionsCount: FQQuizOptionsCount
    let quizType: FQQuizType

    var quizRounds: [FQQuizRound]
    private(set) var currentQuizIndex: Int = 0
    
    
    init(
        quizCount: FQQuizCount,
        quizOptionsCount: FQQuizOptionsCount,
        quizType: FQQuizType
    ) {
        self.quizCount = quizCount
        self.quizOptionsCount = quizOptionsCount
        self.quizType = quizType
        self.quizRounds = Self.createQuizRounds(
            quizCount: quizCount.rawValue,
            quizOptionsCount: quizOptionsCount.rawValue,
            quizType: quizType
        )
        
    }
    
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
    
    public func getQuizRoundResult(by type: FQQuizType? = nil) -> (correct: [FQCountryISOCode], wrong: [FQCountryISOCode]) {
        quizRounds
            .filter {
                guard let expectingType = type else { return true }
                let quizType: FQQuizType = $0.quizType ?? .chooseNameFromFlag
                return quizType == expectingType
            }
            .reduce(([FQCountryISOCode](), [FQCountryISOCode]())) { partial, currentRound in
                
                guard let submittedCountryCode = currentRound.submittedCountryCode else { return partial }
                
                if currentRound.answerCountryCode == submittedCountryCode {
                    return (partial.0 + [currentRound.answerCountryCode], partial.1)
                }
                
                return (partial.0, partial.1 + [currentRound.answerCountryCode])
            }
    }
    
    public func getQuizRoundResultCount(by type: FQQuizType) -> (correct: Int, total: Int) {
        let result = getQuizRoundResult(by: type)
        return (result.correct.count , result.correct.count + result.wrong.count)
    }
    
    mutating func toNextIndex() {
        guard currentQuizIndex < (quizCount.rawValue - 1) else { return }
        currentQuizIndex += 1
    }
    
    
    
    static private func createQuizRounds(quizCount: Int, quizOptionsCount: Int, quizType: FQQuizType) -> [FQQuizRound] {
        FQCountryISOCode.randomCode(of: quizCount, except: nil).map {
            FQQuizRound(answerCountryCode: $0, quizOptionsCount: quizOptionsCount, quizType: quizType)
        }
    }
}

extension FQQuiz: Hashable { }

extension FQQuiz {
    init(
        quizCount: FQQuizCount,
        quizOptionsCount: FQQuizOptionsCount,
        quizType: FQQuizType,
        quizRounds: [FQQuizRound]
    ) {
        self.quizCount = quizCount
        self.quizOptionsCount = quizOptionsCount
        self.quizType = quizType
        self.quizRounds = quizRounds
    }
    
    
    func toRecordObject() -> FQQuizRecordObject {
        .init(
            quizCount: quizCount.rawValue,
            quizOptionsCount: quizOptionsCount.rawValue,
            quizRounds: quizRounds.map { $0.toRecordObject() },
            createdAt: .init(date: .now)
        )
    }
}


