//
//  FQEarthCandy.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation

struct FQEarthCandy: Codable {
    let userId: String
    let point: Double
}

extension FQEarthCandy {
    func toObject() -> FQEarthCandyObject {
        .init(userId: nil, point: point)
    }
}

extension FQEarthCandy {
    static var earthCandyPointForFeedingFrog: Double {
        10.5
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
        let pointPerRound: Decimal = Decimal(quizResult.quizOptionsCount) / 10
        let correctCount: Decimal = Decimal(quizResult.correctQuizRoundsCount)
        let advantagePoint: Decimal = Decimal(quizResult.quizType.advantagePoint)
        let total = NSDecimalNumber(decimal: pointPerRound * correctCount + advantagePoint).doubleValue
       
        
        return .init(
            userId: userId,
            point: total
        )
    }

}
