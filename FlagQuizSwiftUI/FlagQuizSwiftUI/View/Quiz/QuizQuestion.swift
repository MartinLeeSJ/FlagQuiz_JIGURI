//
//  QuizQuestion.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/29/23.
//

import SwiftUI

struct QuizQuestion: View {
    @EnvironmentObject private var viewModel: QuizViewModel
    
    var body: some View {
        HStack {
            Text("Q\(viewModel.quiz.currentQuizIndex + 1)")
                .padding()
                .background(.ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8))
                .padding(.trailing)
            
            questionText
        }
        .font(.subheadline)
        .padding()
        .background(.thickMaterial,
                    in: Rectangle())
        .overlay(alignment: .bottom) {
            QuizProgressView(
                quizRounds: viewModel.quiz.quizRounds,
                currentQuizIndex: viewModel.quiz.currentQuizIndex,
                quizCount: viewModel.quiz.quizCount
            )
            .frame(height: 5)
        }
        .padding(.vertical)
    }
    
    private var questionText: some View {
        let quizType = viewModel.quiz.currentQuizRound.quizType ?? .chooseNameFromFlag
        
        return Group {
            switch quizType {
            case .chooseNameFromFlag:
                Text("quizview.question.chooseNameFromFlag")
            case .chooseFlagFromName:
                Text("quizview.question.chooseFlagFromName")
            case .chooseCaptialFromFlag:
                Text("quizview.question.chooseCaptialFromFlag")
            case .random:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.leading)
    }
}

