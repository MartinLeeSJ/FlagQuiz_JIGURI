//
//  QuizRoundsResultScroll.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

struct QuizRoundsResultScroll: View {
    private let quizResult: FQQuiz
    
    init(quizResult: FQQuiz) {
        self.quizResult = quizResult
    }
    
    private let rows: [GridItem] = .init(
        repeating: .init(.flexible(minimum: 60, maximum: 80), spacing: 0),
        count: 1
    )
    
    private func resultColor(of round: FQQuizRound) -> Color {
        guard let submittedCountryCode = round.submittedCountryCode else {
            return Color.gray.opacity(0.5)
        }
        
        if round.answerCountryCode == submittedCountryCode {
            return Color.green
        }
        
        return Color.red
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("quiz.result.rounds.record.title")
                .font(.title3.bold())
                .padding(.horizontal)
            
            if #available(iOS 17.0, *) {
                content
                    .scrollTargetBehavior(.paging)
            } else {
                content
            }
           
        }
    }
    
    private var content: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(
                    Array(zip(quizResult.quizRounds.indices, quizResult.quizRounds)),
                    id: \.0
                ) { (index, round) in
                    VStack(spacing: 0) {
                        resultBox(of: round)
                        
                        Text("Q\(index + 1)")
                            .font(.caption)
                    }
                }
            }
            .safeAreaInset(edge: .leading) {}
        }
        .scrollIndicators(.hidden)
    }
    
    private func resultBox(of round: FQQuizRound) -> some View {
        VStack {
            Text(round.answerCountryCode.flagEmoji ?? "none")
            
            Spacer()
            
            Divider()
            
            Spacer()
            
            resultSymbol(of: round)
          
        }
        .font(.largeTitle)
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .stroke(resultColor(of: round), lineWidth: 1)
        }
        .padding(4)
    }
    
    @ViewBuilder
    private func resultSymbol(of round: FQQuizRound) -> some View {
        if let submittedCountryCode = round.submittedCountryCode {
            submittedCountryCode == round.answerCountryCode ?
            Image(systemName: "circlebadge")
                .foregroundStyle(resultColor(of: round)) :
            Image(systemName: "xmark")
                  .foregroundStyle(resultColor(of: round))

        } else {
            Image(systemName: "questionmark.square.dashed")
                  .foregroundStyle(resultColor(of: round))
        }
    }
}
