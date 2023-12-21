//
//  QuizSettingViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

enum QuizDestination: Hashable {    
    case quiz
    case quizResult(FQQuiz)
    case countryDetail(FQCountryISOCode)
}

final class QuizSettingViewModel: ObservableObject {
    @Published var quizCount: QuizCount = .ten
    @Published var quizItemCount: QuizItemCount = .four
    @Published var destinations: NavigationPath = .init()
    
}

enum QuizCount: Int, Hashable, CaseIterable {
    case five = 5
    case ten = 10
    case fifteen = 15
}

enum QuizItemCount: Int, Hashable, CaseIterable {
    case three = 3
    case four = 4
    case five = 5
}
