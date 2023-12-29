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

extension FQQuizRoundRecordObject {
    func toModel() -> FQQuizRoundRecord {
        .init(
            answerCountryCode: .init(answerCounrtyCode),
            submittedCountryCode: .init(submittedCountryCode),
            optionsCountryCodes: optionsCountryCodes.map { .init($0) },
            quizType: quizType != nil ? .init(rawValue: quizType!) : .chooseNameFromFlag
        )
    }
}


