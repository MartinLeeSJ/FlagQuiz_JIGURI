//
//  FQQuizScore.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

struct FQQuizScore: Codable {
    let correctQuizCount: Int
    let totalQuizCount: Int
    
    var wrongQuizCount: Int {
        totalQuizCount - correctQuizCount
    }
    
    var classifiedScore: ClassifiedScore {
        ClassifiedScore.classifyScore(correctQuizCount, totalQuizCount: totalQuizCount)
    }
    
    var scalarScore: Int {
        10 * correctQuizCount - wrongQuizCount
    }
    
    var scoreFractionDescription: String {
        return "\(correctQuizCount) / \(totalQuizCount)"
    }
    
    init(correctQuizCount: Int, totalQuizCount: Int) {
        self.correctQuizCount = correctQuizCount
        self.totalQuizCount = totalQuizCount
    }
    
    
    enum ClassifiedScore {
        case high
        case middleHigh
        case middle
        case middleLow
        case low

        
        static func classifyScore(_ scoreNumber: Int, totalQuizCount: Int) -> Self {
            let score: Double = Double(scoreNumber) / Double(totalQuizCount)
            
            switch score {
            case 0.0..<0.2: return Self.low
            case 0.2..<0.4: return Self.middleLow
            case 0.4..<0.6: return Self.middle
            case 0.6..<0.8: return Self.middleHigh
            case 0.8...: return Self.high
            default: return Self.low
            }
        }
        
        var description: String {
            switch self {
            case .high:
                // 이 지구의 참된 시민이십니다
                return String(
                    localized: "You are a true citizen of this Earth!",
                    defaultValue:"You are a true citizen of this Earth!",
                    comment: "Quiz result comment for high score"
                )
            case .middleHigh:
                //"상식이 풍부하시네요!"
                return String(
                    localized: "You certainly have a rich knowledge about Earth's neighbors!",
                    defaultValue:"You certainly have a rich knowledge about Earth's neighbors!",
                    comment: "Quiz result comment for middle-high score"
                )
            case .middle, .middleLow:
                // "지구의 이웃들에게 조금만 더 관심을 가져볼까요?"
                return String(
                    localized: "How about showing a little more interest in Earth's neighbors?",
                    defaultValue: "How about showing a little more interest in Earth's neighbors?",
                    comment: "Quiz result comment for middle, middle-low score"
                )
            case .low:
                // "지구의 이웃들에게 관심이 너무 없으시군요."
                return String(
                    localized: "It appears you're not very interested in Earth's neighbors.",
                    defaultValue: "It appears you're not very interested in Earth's neighbors.",
                    comment: "Quiz result comment for low score"
                )
            }
        }
        
        var badge: Image {
            switch self {
            case .high: Image(systemName: "a.square.fill")
            case .middleHigh: Image(systemName: "b.square.fill")
            case .middle: Image(systemName: "c.square.fill")
            case .middleLow: Image(systemName: "d.square.fill")
            case .low: Image(systemName: "f.square.fill")
            }
        }
        
        var tintColor: Color {
            switch self {
            case .high: Color.fqHigh
            case .middleHigh: Color.fqMiddleHigh
            case .middle: Color.fqMiddle
            case .middleLow: Color.fqMiddleLow
            case .low: Color.fqLow
            }
        }
        
        
    }
}
