//
//  QuizProgressView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/14/24.
//

import SwiftUI

struct QuizProgressView: View {
    private let quizRounds: [FQQuizRound]
    private let currentQuizIndex: Int
    private let quizCount: Int
    
    init(
        quizRounds: [FQQuizRound],
        currentQuizIndex: Int,
        quizCount: Int
    ) {
        self.quizRounds = quizRounds
        self.currentQuizIndex = currentQuizIndex
        self.quizCount = quizCount
    }
    
    
    private func progressBarColor(
        ofQuizRound round: FQQuizRound,
        isRevealed: Bool
    ) -> Color {
        guard isRevealed else {
            return .secondary
        }
        
        guard let submittedCountryCode = round.submittedCountryCode else {
            return .secondary
        }
        
        let result: Bool = round.answerCountryCode == submittedCountryCode
        return result ? .fqAccent : .red
    }
    
    var body: some View {
        GeometryReader { geometry in
            let spacing: CGFloat = geometry.size.width * 0.1 / CGFloat((quizCount - 1))
            let width: CGFloat = geometry.size.width * 0.9 / CGFloat(quizCount)
            
            HStack(spacing: 0) {
                ForEach(0..<quizCount, id: \.self) { index in
                    let isRevealed: Bool = currentQuizIndex > index
                    let color: Color = progressBarColor(
                        ofQuizRound: quizRounds[index],
                        isRevealed: isRevealed
                    )
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: width)
                            .foregroundStyle(color)
                            .shadow(
                                color: isRevealed ? color.opacity(0.5) : .clear,
                                radius: 2
                            )

                        if index != quizCount - 1 {
                            Rectangle()
                                .foregroundStyle(.clear)
                                .frame(width: spacing)
                        }
                    }
                }
            }
        }
    }
}



