//
//  QuizDestination.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import Foundation

enum QuizDestination: NavigationDestination {
    case quiz
    case quizResult(FQQuiz)
    case countryDetail(FQCountryISOCode)
}
