//
//  QuizView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import IsoCountryCodes

struct QuizView: View {
    @StateObject private var viewModel: QuizViewModel
    
    init(viewModel: QuizViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var answerCountryFlagEmoji: String {
        let code = currentQuizRound.answerCountryCode.numericCode
        return IsoCountryCodes.find(key: code)?.flag ?? "정보없음"
    }

    
    var body: some View {
        VStack {
            Spacer()
            Text(answerCountryFlagEmoji)
                .font(.largeTitle)
            Spacer()
            HStack {
                Text("Q\(viewModel.quiz.currentQuizIndex + 1)")
                    .padding()
                    .background(.ultraThinMaterial,
                                in: RoundedRectangle(cornerRadius: 8))
                    .padding(.trailing)
                
                Text("다음이 나타내는 국가 혹은 지역은 아래 중 무엇일까요?")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            .background(.thickMaterial,
                        in: Rectangle())
            .padding(.vertical)
            
            QuizOptionsGrid(viewModel: viewModel)
                .animation(.easeInOut, value: viewModel.isSubmitted)
            
            QuizSubmitButton(viewModel: viewModel)
                .animation(.easeInOut, value: viewModel.isSubmitted)
                .padding()
        }
    }
}


#Preview {
    QuizView(viewModel: QuizViewModel(quizCount: 10, quizOptionsCount: 4))
}
