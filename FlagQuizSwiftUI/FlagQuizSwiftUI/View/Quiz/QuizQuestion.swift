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
            let current = Float(viewModel.quiz.currentQuizIndex)
            let total = Float(viewModel.quiz.quizCount)
            
            ProgressView(value: .init(current/total))
                .animation(.easeIn(duration: 1.5), value: viewModel.quiz.currentQuizIndex)
                .progressViewStyle(.linear)
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

