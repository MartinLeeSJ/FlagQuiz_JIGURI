//
//  FQQuizRound.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation

struct FQQuizRound {
    let answerCountryCode: FQCountryISOCode
    var submittedCountryCode: FQCountryISOCode?
    let optionsCountryCodes: [FQCountryISOCode]
    
    private let quizOptionsCount: Int
    
    init(answerCountryCode: FQCountryISOCode, quizOptionsCount: Int) {
        self.answerCountryCode = answerCountryCode
        self.quizOptionsCount = quizOptionsCount
        self.optionsCountryCodes = Self.optionsCountryCodes(quizOptionsCount: quizOptionsCount,
                                                           answerCountryCode: answerCountryCode)
    }
    
    
    static private func optionsCountryCodes(
        quizOptionsCount: Int,
        answerCountryCode: FQCountryISOCode
    ) -> [FQCountryISOCode] {
        var options: [FQCountryISOCode] = FQCountryISOCode.chooseRandomly(quizOptionsCount - 1, except: answerCountryCode)
        options.append(answerCountryCode)
        
        return options.shuffled()
    }
}

extension FQQuizRound: Equatable { }
