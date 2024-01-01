//
//  FQQuizRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation

struct FQQuizRecord: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let quizCount: Int
    let quizOptionsCount: Int
    let quizRounds: [FQQuizRoundRecord]
    let createdAt: Date
}

extension FQQuizRecord {
    private func correctQuizCount(of quizRounds: [FQQuizRoundRecord]) -> Int {
        quizRounds.reduce(0) { partialResult, record in
            guard let submittedCountryCode = record.submittedCountryCode else {
                return partialResult
            }
            
            return record.answerCountryCode == submittedCountryCode ? (partialResult + 1) : partialResult
        }
    }
    
    private func quizRoundsByType(_ expecting: FQQuizType) -> [FQQuizRoundRecord] {
        quizRounds.filter {
            guard let quizType = $0.quizType else { return false }
            return quizType == expecting
        }
    }
    
    public func quizResultByType(_ expecting: FQQuizType) -> String {
        let rounds: [FQQuizRoundRecord] = quizRoundsByType(expecting)
        guard !rounds.isEmpty else { return String(localized: "no.data") }
        
        let correctQuizCount: Int = correctQuizCount(of: rounds)
        
        return String(localized: "\(correctQuizCount) / \(rounds.count)")
    }
    
    var score: FQQuizScore {
        .init(correctQuizCount: correctQuizCount(of: quizRounds), totalQuizCount: quizCount)
    }
}


