//
//  QuizSubmitButton.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizSubmitButton: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: QuizViewModel

    init(
        viewModel: QuizViewModel
    ) {
        self.viewModel = viewModel
    }
    
    private var quiz: FQQuiz {
        viewModel.quiz ?? .init(quizCount: 10, quizOptionsCount: 4)
    }
    
    private var currentQuizRound: FQQuizRound {
        quiz.currentQuizRound
    }
    
    private var isLastQuiz: Bool {
        quiz.currentQuizIndex == (quiz.quizCount - 1)
    }
    

    var body: some View {
        if viewModel.isSubmitted {
            Button {
                viewModel.send(isLastQuiz ? .finish : .nextQuiz)
                
                if isLastQuiz {
                    withAnimation(.smooth) {
                        viewModel.send(.navigate(to: .quizResult(quiz)))
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

