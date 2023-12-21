//
//  QuizResultView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

struct QuizResultView: View {
    private let quizResult: FQQuiz
    private let quizScore: FQQuizScore
    
    init(quizResult: FQQuiz) {
        self.quizResult = quizResult
        self.quizScore = .init(correctQuizCount: quizResult.correctQuizRoundsCount,
                               totalQuizCount: quizResult.quizCount)
    }
    
   
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 24) {
                scoreDescription
                    .padding(.horizontal)
                QuizRoundsResultScroll(quizResult: quizResult)
                QuizRoundsCountriesInfoView(quizRounds: quizResult.quizRounds)
            }
        }
    }
   
    private var scoreDescription: some View {
        VStack(alignment: .leading) {
            Text(quizScore.localizedDescription)
                .font(.subheadline)
            
            Text(quizScore.classifiedScore.description)
                .font(.title.bold())
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 80)
        .padding(.bottom, 36)
    }
    
        
    
}

#Preview {
    QuizResultView(quizResult: .init(quizCount: 10, quizOptionsCount: 3))
}

