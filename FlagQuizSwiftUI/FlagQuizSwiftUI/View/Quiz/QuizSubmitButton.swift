//
//  QuizSubmitButton.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizSubmitButton: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var settingsViewModel: QuizSettingViewModel
    @ObservedObject private var viewModel: QuizViewModel

    init(
        viewModel: QuizViewModel
    ) {
        self.viewModel = viewModel
    }
    
    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var isLastQuiz: Bool {
        viewModel.quiz.currentQuizIndex == (viewModel.quiz.quizCount - 1)
    }
    

    var body: some View {
        if viewModel.isSubmitted {
            Button {
                viewModel.send(isLastQuiz ? .finish : .nextQuiz)
                
                if isLastQuiz {
                    withAnimation(.smooth) {
                        settingsViewModel.destinations.append(QuizDestination.quizResult(viewModel.quiz))
                    }
                }
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

