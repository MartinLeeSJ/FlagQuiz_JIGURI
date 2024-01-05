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
        .init(userId: userId, point: point)
    }
}

extension FQEarthCandy {
    static func calculatePoint(
        from quizResult: FQQuiz,
        ofUser userId: String
    ) -> FQEarthCandy {
        let pointPerRound: Double = Double(quizResult.quizOptionsCount) * 0.1
        let correctCount: Double = Double(quizResult.correctQuizRoundsCount)
        let advantagePoint: Double = quizResult.quizType.advantagePoint
        
        return .init(
            userId: userId,
            point: pointPerRound * correctCount + advantagePoint
        )
    }
}
