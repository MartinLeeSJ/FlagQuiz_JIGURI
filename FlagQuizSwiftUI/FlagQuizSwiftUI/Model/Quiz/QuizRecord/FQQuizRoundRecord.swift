//
//  FQQuizRoundRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation

struct FQQuizRoundRecord: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let answerCountryCode: FQCountryISOCode
    let submittedCountryCode: FQCountryISOCode?
    let optionsCountryCodes: [FQCountryISOCode]
    let quizType: FQQuizType?
}
