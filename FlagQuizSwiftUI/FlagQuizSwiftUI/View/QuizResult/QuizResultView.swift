//
//  QuizResultView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

enum QuizResultViewAnimationID: String {
    case badge
    case classifiedScoreDescription
    case description
    case earthCandy
}

struct QuizResultView: View {
    @EnvironmentObject private var viewModel: QuizViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var showScoreDetail: Bool = true
    @Namespace private var scoreAnimation
    
    private let quizResult: FQQuiz
    private let quizScore: FQQuizScore
    
    init(quizResult: FQQuiz) {
        self.quizResult = quizResult
        self.quizScore = .init(correctQuizCount: quizResult.correctQuizRoundsCount,
                               totalQuizCount: quizResult.quizCount.rawValue)
    }
    

    var body: some View {
        ZStack {
            if showScoreDetail {
                QuizResultScoreCard(
                    showScoreDetail: $showScoreDetail,
                    quizResult: quizResult,
                    quizScore: quizScore,
                    scoreAnimation: scoreAnimation
                )
            } else {
                content
            }
        }
    }
    
    private var content: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 24) {
                QuizResultScoreSection(
                    quizResult: quizResult,
                    quizScore: quizScore,
                    scoreAnimation: scoreAnimation
                )
                .padding(.top, 36)
                .padding(.bottom, 36)
                .padding(.horizontal)
                
                QuizRoundsResultScroll(quizResult: quizResult)
                QuizRoundsCountriesInfoView(quizRounds: quizResult.quizRounds)
                
                Spacer()
                    .frame(height: 32)
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
    
}


