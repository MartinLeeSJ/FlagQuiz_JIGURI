//
//  FQUserQuizStat.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

struct FQUserQuizStat: Codable {
    var userId: String
    var totalCorrectQuizCount: Int {
        (correctCapitalQuizCount ?? 0) + (correctFlagToNameQuizCount ?? 0) + (correctNameToFlagQuizCount ?? 0)
    }
    var totalQuizCount: Int {
        (capitalQuizCount ?? 0) + (flagToNameQuizCount ?? 0) + (nameToFlagQuizCount ?? 0)
    }
    var totalAccuracy: Double {
        Double(totalCorrectQuizCount) / Double(totalQuizCount)
    }
    
    var correctCapitalQuizCount: Int?
    var capitalQuizCount: Int?
    var capitalQuizAccuracy: Double? {
        accuracy(correct: correctCapitalQuizCount, total: capitalQuizCount)
    }
    
    var correctFlagToNameQuizCount: Int?
    var flagToNameQuizCount: Int?
    var flagToNameQuizAccuracy: Double? {
        accuracy(correct: correctFlagToNameQuizCount, total: flagToNameQuizCount)
    }
    
    var correctNameToFlagQuizCount: Int?
    var nameToFlagQuizCount: Int?
    var nameToFlagQuizAccuracy: Double? {
        accuracy(correct: correctNameToFlagQuizCount, total: nameToFlagQuizCount)
    }
    
    private func accuracy(correct: Int?, total: Int?) -> Double? {
        guard let correct,
              let total else { return nil }
        
        guard total != 0 else { return 0.0 }
        
        return Double(correct) / Double(total)
    }
    
    var rank: FQUserRank {
        .evaluateOnesRank(
            correctQuizCount: totalCorrectQuizCount,
            totalQuizCount: totalQuizCount
        )
    }
}

extension FQUserQuizStat {
    static var mock: FQUserQuizStat {
        .init(
            userId: "1",
            correctCapitalQuizCount: 30,
            capitalQuizCount: 40,
            correctFlagToNameQuizCount: 50,
            flagToNameQuizCount: 60,
            correctNameToFlagQuizCount: 100,
            nameToFlagQuizCount: 100
        )
    }
}
