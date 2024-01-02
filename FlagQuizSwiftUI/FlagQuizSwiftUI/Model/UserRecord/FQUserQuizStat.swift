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
    
    var correctCaptialQuizCount: Int?
    var captialQuizCount: Int?
    
    var correctFlagToNameQuizCount: Int?
    var flagToNameQuizCount: Int?
    
    var correctNameToFlagQuizCount: Int?
    var nameToFlagQuizCount: Int?
    
    var rank: FQUserRank {
        .evaluateOnesRank(
            correctQuizCount: correctCountryQuizCount,
            totalQuizCount: countryQuizCount
        )
    }
}
