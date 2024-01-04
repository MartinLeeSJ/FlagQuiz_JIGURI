//
//  QuizOptions.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import Combine

struct QuizOptions: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: QuizViewModel
    
    private var quiz: FQQuiz {
        viewModel.quiz
    }
    
    private var currentQuizRound: FQQuizRound {
        quiz.currentQuizRound
    }
    
    private var columns: [GridItem] {
        let isOddCount: Bool = (quiz.quizOptionsCount) % 2 != 0
        let columnsCount: Int = isOddCount ? 3 : 2
        
        return Array(
            repeating: GridItem(.flexible(minimum: 100, maximum: .infinity), spacing: 8),
            count: columnsCount
        )
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(
                currentQuizRound.optionsCountryCodes,
                id: \.self
            ) { code in
                if viewModel.isSubmitted {
                    optionsResultButton(of: code)
                } else {
                    optionsButton(of: code)
                }
            }
        }
        .onReceive(Just(currentQuizRound)){ quizRound in
            guard let quizType = currentQuizRound.quizType else { return }
            if quizType == .chooseCaptialFromFlag {
                viewModel.send(.loadOptionsCountryInfo(quizRound.optionsCountryCodes))
            }
        }
        .frame(minHeight: 208)
        .padding(.horizontal)
    }

    private func optionsButton(of code: FQCountryISOCode) -> some View {
        Button {
            viewModel.send(.selectQuizOption(code))
        } label: {
            optionButtonLabel(of: code)
        }
        .buttonStyle(
            QuizOptionButtonStyle(isSelected: currentQuizRound.submittedCountryCode == code)
        )
        .id(UUID())
    }
    
    private func optionsResultButton(of code: FQCountryISOCode) -> some View {
        var submission: QuizSubmission {
            if currentQuizRound.answerCountryCode == code { return .correct }
            
            if currentQuizRound.submittedCountryCode == code { return .wrongSubmitted }
            
            return .none
        }
        
        return Button {
            
        } label: {
            optionButtonLabel(of: code)
        }
        .buttonStyle(
            QuizOptionResultButtonStyle(submission: submission)
        )
        .id(UUID())
    }
    
    private func optionButtonLabel(of code: FQCountryISOCode) -> some View {
        let quizType = currentQuizRound.quizType ?? .chooseNameFromFlag
        
        return Group {
            switch quizType {
            case .chooseNameFromFlag:
                Text(code.localizedName ?? "-")
            case .chooseFlagFromName:
                Text(code.flagEmoji ?? "-")
                    .font(.system(size: 40))
                    .shadow(
                        color: scheme == .dark ? .white.opacity(0.6) : .clear,
                        radius: 20
                    )
                    
            case .chooseCaptialFromFlag:
                capitalOptionButtonLabel(of: code)
            case .random:
                EmptyView()
            }
        }
    }
    
    private func capitalOptionButtonLabel(of code: FQCountryISOCode) -> some View {
        return Group {
            if let country = viewModel.optionsCountries.first(where: { $0.id == code }),
               let capitals = country.capitals  {
                Text(capitals.joined(separator: ", "))
            } else {
                Text("placeholder")
                    .redacted(reason: .placeholder)
            }
        }
    }
}


