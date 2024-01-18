//
//  FQQuizType.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation


enum FQQuizType: String, Hashable, CaseIterable {
    /// 국기를 보고 나라 이름을 맞추기
    case chooseNameFromFlag
    /// 나라 이름을 보고 국기를 맞추기
    case chooseFlagFromName
    /// 국기를 보고 수도를 맞추기
    case chooseCaptialFromFlag
    
    case random
    
    var localizedTitle: String {
        switch self {
        case .chooseNameFromFlag:
            String(localized: "quizType.choose.name.from.flag.title")
        case .chooseFlagFromName:
            String(localized: "quizType.choose.flag.from.name.title")
        case .chooseCaptialFromFlag:
            String(localized: "quizType.choose.capital.from.flag.title")
        case .random:
            String(localized: "quizType.random.title")
        }
    }
    
    var localizedShortenedTitle: String {
        switch self {
        case .chooseNameFromFlag:
            String(localized: "quizType.choose.name.from.flag.shortened.title")
        case .chooseFlagFromName:
            String(localized: "quizType.choose.flag.from.name.shortened.title")
        case .chooseCaptialFromFlag:
            String(localized: "quizType.choose.capital.from.flag.shortened.title")
        case .random:
            String(localized: "quizType.random.shortened.title")
        }
    }
    
    var advantageCandy: Int {
        switch self {
        case .chooseNameFromFlag: 1
        case .chooseFlagFromName: 1
        case .chooseCaptialFromFlag: 2
        case .random: 3
        }
    }
}
