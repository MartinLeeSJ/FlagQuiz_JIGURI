//
//  QuizSubmitButton.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizSubmitButton: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var hapticsManager: HapticsManager
    @ObservedObject private var viewModel: QuizViewModel

    init(
        viewModel: QuizViewModel
    ) {
        self.viewModel = viewModel
    }
    
    private var quiz: FQQuiz {
        viewModel.quiz
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
                if isLastQuiz {
                    withAnimation(.smooth) {
                        viewModel.send(.finishQuiz)
                        viewModel.send(.navigate(to: .quizResult(quiz)))
                    }
                } else {   
                    viewModel.send(.nextQuiz)
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
                
                if let submittedCountryCode = currentQuizRound.submittedCountryCode {
                    let isAnswerCorrect: Bool = (currentQuizRound.answerCountryCode == submittedCountryCode)
                    hapticsManager.send(.complex(isAnswerCorrect ? .correct : .wrong))
                }
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

