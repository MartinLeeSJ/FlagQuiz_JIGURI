//
//  QuizResultScoreSection.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/7/24.
//

import SwiftUI

struct QuizResultScoreSection: View {
    @Environment(\.colorScheme) private var scheme
    
    private let quizResult: FQQuiz
    private let quizScore: FQQuizScore
    private var scoreAnimation: Namespace.ID
    
    init(
        quizResult: FQQuiz,
        quizScore: FQQuizScore,
        scoreAnimation: Namespace.ID
    ) {
        self.quizResult = quizResult
        self.quizScore = quizScore
        self.scoreAnimation = scoreAnimation
    }
    
    private var quizOptionPoint: Double {
        Double(quizResult.quizOptionsCount) / 10.0
    }
    private var estimatedCandy: Double {
        let quizCount: Double = Double(quizScore.correctQuizCount)
        
        return quizCount * quizOptionPoint + quizResult.quizType.advantagePoint
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            quizScore.classifiedScore.badge
                .resizable()
                .foregroundStyle(
                    .white,
                    quizScore.classifiedScore.tintColor
                )
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.badge,
                    in: scoreAnimation
                )
                .scaledToFit()
                .frame(height: 30)
                .padding(.vertical, 16)
            
            
            Text("\(quizResult.correctQuizRoundsCount).out.of.\(quizResult.quizCount).problems")
                .font(.subheadline)
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.description,
                    in: scoreAnimation
                )
            
            
            Text(quizScore.classifiedScore.description)
                .font(.title3.bold())
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .matchedGeometryEffect(
                    id: QuizResultViewAnimationID.classifiedScoreDescription,
                    in: scoreAnimation
                )
            
            
            HStack(spacing: 0) {
                Text("you.have.got")
                    .font(.subheadline)
                    .padding(.trailing, 4)
                
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .padding(.trailing, 2)
                
                Text(estimatedCandy, format: .number)
            }
            .fontWeight(.medium)
            .matchedGeometryEffect(
                id: QuizResultViewAnimationID.earthCandy,
                in: scoreAnimation
            )
        }
    }
}

