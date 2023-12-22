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
    @Published var quiz: FQQuiz = .init(quizCount: 10, quizOptionsCount: 4)
    @Published var isSubmitted: Bool = false
    @Published var countries: [FQCountry] = []
    
    @Published var destinations: NavigationPath = .init()
//    @Published var destinations: [QuizDestination] = .init()
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case setNewQuiz(count: Int, optionCount: Int)
        case navigate(to: QuizDestination)
        case backToRoot
        
        case loadCountryInfo
        case selectQuizOption(_ code: FQCountryISOCode)
        case submit
        case nextQuiz
        case finishQuiz
    }
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .setNewQuiz(let count, let optionCount):
            quiz = FQQuiz(quizCount: count, quizOptionsCount: optionCount)
            isSubmitted = false
            
        case .navigate(to: let destination):
            destinations.append(destination)
            
        case .backToRoot:
            while !destinations.isEmpty {
                destinations.removeLast()
            }
            
        case .loadCountryInfo:
            loadCountryInfo()
            
        case .selectQuizOption(let code):
           selectQuizOption(of: code)
            
        case .submit:
            isSubmitted = true
            
        case .nextQuiz:
            quiz.toNextIndex()
            isSubmitted = false
            
        case .finishQuiz:
            Task {
                await finishQuiz()
            }
        }
    }
    
    private func loadCountryInfo() {
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
        quiz.quizRounds[quiz.currentQuizIndex].submittedCountryCode = code
    }
    
    
    private func finishQuiz() async {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
        }
        
        await addUserQuizStat(userId: userId)
        addQuizRecord(userId: userId)
    }
    
    @MainActor
    private func addUserQuizStat(userId: String) async {
        do {
            try await container.services.quizStatService.addQuizStat(
                ofUser: userId,
                addingQuizCount: quiz.quizCount,
                addingCorrectQuizCount: quiz.correctQuizRoundsCount
            )
        } catch {
            //TODO: Error 처리
            print(error.localizedDescription)
        }
    }
    
    private func addQuizRecord(userId: String) {
        do {
            try container.services.quizRecordService.addQuizRecord(ofUser: userId, from: quiz)
        } catch {
            //TODO: Error 처리
            print(error.localizedDescription)
        }
    }
}
