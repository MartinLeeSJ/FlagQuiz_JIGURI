//
//  QuizAnswer.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/29/23.
//

import SwiftUI

struct QuizAnswer: View {
    @EnvironmentObject private var viewModel: QuizViewModel
 
    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var quizType: FQQuizType {
        currentQuizRound.quizType ?? .chooseNameFromFlag
    }
    
    private var answerCountryFlagEmoji: String {
        let code = currentQuizRound.answerCountryCode
        return code.flagEmoji ?? "정보없음"
    }
    
    private var flagImageUrl: URL? {
        if let country = viewModel.countries.first(where: {
            $0.id == currentQuizRound.answerCountryCode
        }) {
            return country.flagLinks.pngURL
        }
        return nil
    }
    
    
    var body: some View {
        ZStack {
            switch quizType {
            case .chooseNameFromFlag, .chooseCaptialFromFlag:
                URLImageView(flagImageUrl?.absoluteString) {
                    Text(answerCountryFlagEmoji)
                        .font(.system(size: 96))
                }
                .scaledToFit()
                .frame(maxHeight: 100)
                
            case .chooseFlagFromName:
                Text(currentQuizRound.answerCountryCode.localizedName ?? "Error has been occured")
                    .font(.title3)
                    .fontWeight(.medium)
            
            case .random:
                EmptyView()
            }
           
        }
        .frame(minHeight: 180, idealHeight: 180, maxHeight: 200)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: Rectangle())
        .padding(.bottom, 16)
    }
}


