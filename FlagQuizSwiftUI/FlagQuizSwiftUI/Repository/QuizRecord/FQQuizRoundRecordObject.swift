//
//  FQQuizRoundRecordObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation

struct FQQuizRoundRecordObject: Codable {
    let answerCounrtyCode: String
    let submittedCountryCode: String?
    let optionsCountryCodes: [String]
    let quizType: String?
}



