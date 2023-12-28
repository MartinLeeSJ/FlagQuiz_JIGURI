//
//  FQQuizRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation

struct FQQuizRecord: Identifiable {
    let id: String = UUID().uuidString
    let quizCount: Int
    let quizOptionsCount: Int
    let quizRounds: [FQQuizRoundRecord]
    let createdAt: Date
    
    init(
        quizCount: Int,
        quizOptionsCount: Int,
        quizRounds: [FQQuizRoundRecord],
        createdAt: Date
    ) {
        self.quizCount = quizCount
        self.quizOptionsCount = quizOptionsCount
        self.quizRounds = quizRounds
        self.createdAt = createdAt
    }
}
