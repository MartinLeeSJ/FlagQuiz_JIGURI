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
    let quizType: FQQuizType?
    
    private let quizOptionsCount: Int
    
    /// QuizType이 Random인 Initializer
    /// - Parameters:
    ///   - answerCountryCode: 정답이 되는 국가의 코드
    ///   - quizOptionsCount: 퀴즈 선택지 개수
    init(
        answerCountryCode: FQCountryISOCode,
        quizOptionsCount: Int
    ) {
        self.answerCountryCode = answerCountryCode
        self.quizOptionsCount = quizOptionsCount
        self.optionsCountryCodes = Self.optionsCountryCodes(quizOptionsCount: quizOptionsCount,
                                                           answerCountryCode: answerCountryCode)
        self.quizType = Self.randomQuizType()
    }
    
    
    /// QuizType을 특정해서 Initializer
    /// - Parameters:
    ///   - answerCountryCode: 정답이 되는 국가의 코드
    ///   - quizOptionsCount: 퀴즈 선택지 개수
    ///   - quizType: 특정 FQQuizType
    init(
        answerCountryCode: FQCountryISOCode,
        quizOptionsCount: Int,
        quizType: FQQuizType
    ) {
        self.answerCountryCode = answerCountryCode
        self.quizOptionsCount = quizOptionsCount
        self.optionsCountryCodes = Self.optionsCountryCodes(quizOptionsCount: quizOptionsCount,
                                                           answerCountryCode: answerCountryCode)
        self.quizType = quizType
    }
    
    
    
    static private func optionsCountryCodes(
        quizOptionsCount: Int,
        answerCountryCode: FQCountryISOCode
    ) -> [FQCountryISOCode] {
        var options: [FQCountryISOCode] = FQCountryISOCode.randomCode(of: quizOptionsCount - 1, except: answerCountryCode)
        options.append(answerCountryCode)
        
        return options.shuffled()
    }
    
    static private func randomQuizType() -> FQQuizType? {
        FQQuizType.allCases.randomElement()
    }
}

extension FQQuizRound: Equatable { }
extension FQQuizRound: Hashable { }

extension FQQuizRound {
    func toRecordObject() -> FQQuizRoundRecordObject {
        .init(
            answerCounrtyCode: answerCountryCode.numericCode,
            submittedCountryCode: submittedCountryCode?.numericCode,
            optionsCountryCodes: optionsCountryCodes.map { $0.numericCode },
            quizType: quizType?.rawValue
        )
    }
}
