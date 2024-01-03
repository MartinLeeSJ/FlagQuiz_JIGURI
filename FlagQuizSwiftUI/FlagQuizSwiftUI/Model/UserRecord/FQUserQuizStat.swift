//
//  FQUserQuizStat.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

struct FQUserQuizStat: Codable {
    var userId: String
    var correctCountryQuizCount: Int
    var countryQuizCount: Int
    var totalAccuracy: Double {
        Double(correctCountryQuizCount) / Double(countryQuizCount)
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
        
        return Double(correct) / Double(total)
    }
    
    var rank: FQUserRank {
        .evaluateOnesRank(
            correctQuizCount: correctCountryQuizCount,
            totalQuizCount: countryQuizCount
        )
    }
}

extension FQUserQuizStat {
    static var mock: FQUserQuizStat {
        .init(
            userId: "1",
            correctCountryQuizCount: 180,
            countryQuizCount: 200,
            correctCapitalQuizCount: 30,
            capitalQuizCount: 40,
            correctFlagToNameQuizCount: 50,
            flagToNameQuizCount: 60,
            correctNameToFlagQuizCount: 100,
            nameToFlagQuizCount: 100
        )
    }
}
