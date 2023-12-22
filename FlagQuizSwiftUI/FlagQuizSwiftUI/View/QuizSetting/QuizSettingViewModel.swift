//
//  QuizSettingViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI



final class QuizSettingViewModel: ObservableObject {
    @Published var quizCount: QuizCount = .ten
    @Published var quizItemCount: QuizItemCount = .four
    @Published var destinations: NavigationPath = .init()
    
}
