//
//  QuizViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation
import Combine

final class QuizViewModel: ObservableObject {
    @Published var quiz: FQQuiz
    @Published var isSubmitted: Bool = false
    @Published var countries: [FQCountry] = []
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case load
        case select(_ code: FQCountryISOCode)
        case submit
        case nextQuiz
        case finish
    }
    
    init(
        container: DIContainer,
        quizCount: Int,
        quizOptionsCount: Int
    ) {
        self.container = container
        self.quiz = FQQuiz(quizCount: quizCount, quizOptionsCount: quizOptionsCount)
    }
    
    func send(_ action: Action) {
        switch action {
        case .load:
            container.services.countryService.getCountries(ofCodes: quiz.quizRounds.map { $0.answerCountryCode })
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] countries in
                    self?.countries = countries
                }
                .store(in: &cancellables)
            
        case .select(let code):
            quiz.quizRounds[quiz.currentQuizIndex].submittedCountryCode = code
        case .submit:
            isSubmitted = true
        case .nextQuiz:
            quiz.toNextIndex()
            isSubmitted = false
        case .finish:
            // 유저정보 저장
            // 퀴즈 정보 저장
            break
        }
    }
}
