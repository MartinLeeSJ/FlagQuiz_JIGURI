//
//  QuizResultView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

struct QuizResultView: View {
    @EnvironmentObject private var viewModel: QuizViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
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
        .navigationBarBackButtonHidden()
        .toolbar {
            Button {
                navigationModel.toRoot()
            } label: {
                Text("save.and.quit")
            }
        }
    }
   
    private var scoreDescription: some View {
        VStack(alignment: .leading) {
            Text("\(quizResult.correctQuizRoundsCount).out.of.\(quizResult.quizCount).problems")
                .font(.subheadline)
            
            Text(quizScore.classifiedScore.description)
                .font(.title.bold())
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
        }
        .padding(.top, 60)
        .padding(.bottom, 36)
    }
    
        
    
}

#Preview {
    QuizResultView(quizResult: .init(quizCount: 10, quizOptionsCount: 3, quizType: .random))
        .environmentObject(QuizViewModel(container: .init(services: StubService())))
        .environmentObject(NavigationModel())
}

