//
//  FQQuizRoundRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation

struct FQQuizRoundRecord {
    let answerCountryCode: FQCountryISOCode
    let submittedCountryCode: FQCountryISOCode
    let optionsCountryCodes: [FQCountryISOCode]
    
    init(
        answerCountryCode: FQCountryISOCode,
        submittedCountryCode: FQCountryISOCode,
        optionsCountryCodes: [FQCountryISOCode]
    ) {
        self.answerCountryCode = answerCountryCode
        self.submittedCountryCode = submittedCountryCode
        self.optionsCountryCodes = optionsCountryCodes
    }
}
