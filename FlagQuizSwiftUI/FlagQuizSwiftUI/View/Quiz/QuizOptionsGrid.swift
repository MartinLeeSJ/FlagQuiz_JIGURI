//
//  QuizOptionsGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import IsoCountryCodes

struct QuizOptionsGrid: View {
    @ObservedObject private var viewModel: QuizViewModel
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
    }
    
    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var columns: [GridItem] {
        let isOddCount: Bool = (viewModel.quiz.quizOptionsCount) % 2 != 0
        let columnsCount: Int = isOddCount ? 3 : 2
        
        return Array(
            repeating: GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 8),
            count: columnsCount
        )
    }
    
    private func countryName(of code: FQCountryISOCode) -> String {
        let alpha2: String = IsoCountryCodes.find(key: code.numericCode)?.alpha2 ?? ""
        return Locale.current.localizedString(forRegionCode: alpha2) ?? ""
    }
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(
                currentQuizRound.optionsCountryCodes,
                id: \.self
            ) { code in
                if viewModel.isSubmitted {
                    optionsResultButton(of: code)
                        .transition(.move(edge: .leading))
                } else {
                    optionsButton(of: code)
                        .transition(.move(edge: .trailing))
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func optionsButton(of code: FQCountryISOCode) -> some View {
        Button {
            viewModel.send(.select(code))
        } label: {
            Text(countryName(of: code))
        }
        .buttonStyle(
            QuizOptionButtonStyle(isSelected: currentQuizRound.submittedCountryCode == code)
        )
    }
    
    private func optionsResultButton(of code: FQCountryISOCode) -> some View {
        var submission: QuizSubmission {
            if currentQuizRound.answerCountryCode == code { return .correct }
            
            if currentQuizRound.submittedCountryCode == code { return .wrongSubmitted }
            
            return .none
        }
        
        return Button {
            
        } label: {
            Text(countryName(of: code))
        }
        .buttonStyle(
            QuizOptionResultButtonStyle(submission: submission)
        )
    }
}


