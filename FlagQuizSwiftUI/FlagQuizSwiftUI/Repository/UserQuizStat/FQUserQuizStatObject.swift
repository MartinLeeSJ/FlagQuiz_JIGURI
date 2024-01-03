//
//  FQUserQuizStatObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/22/23.
//

import Foundation
import FirebaseFirestore

struct FQUserQuizStatObject: Codable {
    @DocumentID var userId: String?
    var correctCountryQuizCount: Int
    var countryQuizCount: Int
    
    var correctCapitalQuizCount: Int?
    var capitalQuizCount: Int?
    
    var correctFlagToNameQuizCount: Int?
    var flagToNameQuizCount: Int?
    
    var correctNameToFlagQuizCount: Int?
    var nameToFlagQuizCount: Int?
    
    var lastUpdated: Timestamp
    
    
    init(
        correctCountryQuizCount: Int = 0,
        countryQuizCount: Int = 0,
        correctCaptialQuizCount: Int? = nil,
        captialQuizCount: Int? = nil,
        correctFlagToNameQuizCount: Int? = nil,
        flagToNameQuizCount: Int? = nil,
        correctNameToFlagQuizCount: Int? = nil,
        nameToFlagQuizCount: Int? = nil,
        lastUpdated: Timestamp = .init(date: Date.now)
    ) {
        self.correctCountryQuizCount = correctCountryQuizCount
        self.countryQuizCount = countryQuizCount
        self.correctCapitalQuizCount = correctCaptialQuizCount
        self.capitalQuizCount = captialQuizCount
        self.correctFlagToNameQuizCount = correctFlagToNameQuizCount
        self.flagToNameQuizCount = flagToNameQuizCount
        self.correctNameToFlagQuizCount = correctNameToFlagQuizCount
        self.nameToFlagQuizCount = nameToFlagQuizCount
        self.lastUpdated = lastUpdated
    }
    
}

extension FQUserQuizStatObject {
    func toModel() -> FQUserQuizStat? {
        guard let userId else { return nil }
        return .init(
            userId: userId,
            correctCountryQuizCount: correctCountryQuizCount,
            countryQuizCount: countryQuizCount,
            correctCapitalQuizCount: correctCapitalQuizCount,
            capitalQuizCount: capitalQuizCount,
            correctFlagToNameQuizCount: correctFlagToNameQuizCount,
            flagToNameQuizCount: flagToNameQuizCount,
            correctNameToFlagQuizCount: correctNameToFlagQuizCount,
            nameToFlagQuizCount: nameToFlagQuizCount
        )
    }
}
