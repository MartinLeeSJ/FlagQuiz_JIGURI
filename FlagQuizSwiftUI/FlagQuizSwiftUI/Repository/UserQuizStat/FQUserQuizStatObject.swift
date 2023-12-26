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
    
    var correctCaptialQuizCount: Int
    var captialQuizCount: Int
    
    var lastUpdated: Timestamp
    
    init(
        correctCountryQuizCount: Int = 0,
        countryQuizCount: Int = 0,
        correctCaptialQuizCount: Int = 0,
        captialQuizCount: Int = 0,
        lastUpdated: Timestamp = .init(date: Date.now)
    ) {
        self.correctCountryQuizCount = correctCountryQuizCount
        self.countryQuizCount = countryQuizCount
        self.correctCaptialQuizCount = correctCaptialQuizCount
        self.captialQuizCount = captialQuizCount
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
            correctCaptialQuizCount: correctCaptialQuizCount,
            captialQuizCount: captialQuizCount
        )
    }
}
