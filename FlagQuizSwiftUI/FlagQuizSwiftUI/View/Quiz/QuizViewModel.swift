//
//  QuizViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import Combine

enum QuizDestination: Hashable {
    case quiz
    case quizResult(FQQuiz)
    case countryDetail(FQCountryISOCode)
}

final class QuizViewModel: ObservableObject {
    @Published var quiz: FQQuiz?
    @Published var isSubmitted: Bool = false
    @Published var countries: [FQCountry] = []
    
    @Published var destinations: NavigationPath = .init()
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case createQuiz(count: Int, optionCount: Int)
        case navigate(to: QuizDestination)
        case loadCountryInfo
        case selectQuizOption(_ code: FQCountryISOCode)
        case submit
        case nextQuiz
        case finish
    }
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .createQuiz(let count, let optionCount):
            quiz = FQQuiz(quizCount: count, quizOptionsCount: optionCount)
            
        case .navigate(to: let destination):
            destinations.append(destination)
            
        case .loadCountryInfo:
            loadCountryInfo()
            
        case .selectQuizOption(let code):
           selectQuizOption(of: code)
            
        case .submit:
            isSubmitted = true
        case .nextQuiz:
            guard var quiz else { break }
            quiz.toNextIndex()
            isSubmitted = false
            
        case .finish:
            // 유저정보 저장
            // 퀴즈 정보 저장
            break
        }
    }
    
    private func loadCountryInfo() {
        guard let quiz = quiz else { return }
        
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
    }
    
    private func selectQuizOption(of code: FQCountryISOCode) {
        guard var quiz else { return }
        
        quiz.quizRounds[quiz.currentQuizIndex].submittedCountryCode = code
    }
}
