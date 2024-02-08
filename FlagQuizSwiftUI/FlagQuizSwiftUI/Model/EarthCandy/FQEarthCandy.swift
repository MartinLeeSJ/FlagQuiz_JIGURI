//
//  FQEarthCandy.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation

struct FQEarthCandy: Codable {
    let userId: String
    let point: Int
}

extension FQEarthCandy {
    func toObject() -> FQEarthCandyObject {
        .init(userId: nil, point: point)
    }
}

extension FQEarthCandy {
    static var earthCandyPointForFeedingFrog: Int {
        10
    }
    
    static var adRewardCandyPoint: Int {
        40
    }
    
    static var dailyRewardCandyPoint: Int {
        10
    }
    
    static func earthCandyForFeedingFrog(ofUser userId: String) -> FQEarthCandy {
        .init(userId: userId, point: -Self.earthCandyPointForFeedingFrog)
    }
    
    var hasEnoughCandyForFeedFrog: Bool {
        return point >= FQEarthCandy.earthCandyPointForFeedingFrog
    }
    
}

extension FQEarthCandy {
    static func calculatePoint(
        from quizResult: FQQuiz,
        ofUser userId: String
    ) -> FQEarthCandy {
        let correctCount: Int = quizResult.correctQuizRoundsCount
        let quizTypeAdvantageCandy: Int = quizResult.quizType.advantageCandy
        let total: Int = correctCount + quizTypeAdvantageCandy + quizResult.quizOptionsCount.advantageCandy
        
        return .init(
            userId: userId,
            point: total
        )
    }
}
