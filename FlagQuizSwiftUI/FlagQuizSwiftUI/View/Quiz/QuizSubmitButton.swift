//
//  QuizSubmitButton.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizSubmitButton: View {
    @ObservedObject private var viewModel: QuizViewModel
    
    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var isLastQuiz: Bool {
        viewModel.quiz.currentQuizIndex == (viewModel.quiz.quizCount - 1)
    }
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if viewModel.isSubmitted {
            Button {
                viewModel.send(.nextQuiz)
            } label: {
                isLastQuiz ? Text("finish.quiz") : Text("next.quiz")
            }
            .buttonStyle(
                QuizStrokeButtonStyle()
            )
            .transition(.opacity)
        } else {
            Button {
                viewModel.send(.submit)
            } label: {
                Text("submit.quiz")
            }
            .disabled(currentQuizRound.submittedCountryCode == nil)
            .buttonStyle(
                QuizFilledButtonStyle(
                    disabled: currentQuizRound.submittedCountryCode == nil
                )
            )
            .transition(.opacity)
        }
        
    }
}

