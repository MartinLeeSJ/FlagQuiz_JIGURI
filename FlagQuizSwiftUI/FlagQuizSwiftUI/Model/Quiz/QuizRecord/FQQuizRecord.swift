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
    var correctQuizCount: Int {
        quizRounds.reduce(0) { partialResult, record in
            guard let submittedCountryCode = record.submittedCountryCode else {
                return partialResult
            }
            
            return record.answerCountryCode == submittedCountryCode ? (partialResult + 1) : partialResult
        }
    }
    
    var score: FQQuizScore {
        .init(correctQuizCount: correctQuizCount, totalQuizCount: quizCount)
    }
}


