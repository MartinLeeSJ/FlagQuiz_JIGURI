//
//  QuizViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation

final class QuizViewModel: ObservableObject {
    @Published var quiz: FQQuiz
    @Published var isSubmitted: Bool = false
    
    enum Action {
        case select(_ code: FQCountryISOCode)
        case submit
        case nextQuiz
        case finish
    }
    
    init(quizCount: Int, quizOptionsCount: Int) {
        self.quiz = FQQuiz(quizCount: quizCount, quizOptionsCount: quizOptionsCount)
    }
    
    func send(_ action: Action) {
        switch action {
        case .select(let code):
            quiz.quizRounds[quiz.currentQuizIndex].submittedCountryCode = code
        case .submit:
            isSubmitted = true
        case .nextQuiz:
            if !quiz.toNextIndex() { send(.finish) }
            isSubmitted = false
            
        case .finish:
            break
        }
    }
}
