//
//  QuizRecordViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import Foundation

final class QuizRecordViewModel: ObservableObject {
    @Published var quizRecords: [FQQuiz] = []
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
}
