//
//  QuizViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import Combine



final class QuizViewModel: ObservableObject {
    @Published var quiz: FQQuiz = .init(quizCount: .ten, quizOptionsCount: .five, quizType: .chooseNameFromFlag)
    @Published var isSubmitted: Bool = false
    @Published var countries: [FQCountry] = []
    @Published var optionsCountries: [FQCountry] = []
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case setNewQuiz(count: FQQuizCount, optionsCount: FQQuizOptionsCount, quizType: FQQuizType)
        case loadCountryInfo
        case loadOptionsCountryInfo([FQCountryISOCode])
        case selectQuizOption(_ code: FQCountryISOCode)
        case submit
        case nextQuiz
        case finishQuiz
        case error(QuizError)
    }
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    func send(_ action: Action) {
        switch action {
        case .setNewQuiz(let count, let optionsCount, let quizType):
            quiz = FQQuiz(quizCount: count, quizOptionsCount: optionsCount, quizType: quizType)
            isSubmitted = false
                        
        case .loadCountryInfo:
            loadCountryInfo(codes: quiz.quizRounds.map { $0.answerCountryCode })
            
        case .loadOptionsCountryInfo(let codes):
            loadOptionsCountryInfo(of: codes)
            
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
            
        case .error:
            //TODO: - errorHandling
            break
        }
        
    
    }
    
    private func loadCountryInfo(codes: [FQCountryISOCode]) {
        container.services.countryService.getCountries(ofCodes: codes)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    debugPrint(error.localizedDescription)
                    self?.error(.failedToLoadCountryInfo)
                }
            } receiveValue: { [weak self] countries in
                self?.countries = countries
            }
            .store(in: &cancellables)
    }
    
    private func loadOptionsCountryInfo(of codes: [FQCountryISOCode]) {
        guard optionsCountries.map({ $0.id }) != codes else {
            return
        }
        
        container.services.countryService.getCountries(ofCodes: codes)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    debugPrint(error.localizedDescription)
                    self?.error(.failedToLoadOptionsCountryInfo)
                }
            } receiveValue: { [weak self] countries in
                self?.optionsCountries = countries
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
        await addCountryQuizStat(userId: userId)
        addQuizRecord(userId: userId)
        updateEarthCandy(userId: userId)
    }
    
    
    private func addUserQuizStat(userId: String) async {
        do {
            try await container.services.quizStatService.addQuizStat(ofUser: userId, quiz: quiz)
        } catch {
            //TODO: Error 처리
            debugPrint(error.localizedDescription)
            self.error(.failedToUpdateUserQuizStat)
        }
    }
    
    private func addQuizRecord(userId: String) {
        do {
            try container.services.quizRecordService.addQuizRecord(ofUser: userId, from: quiz)
        } catch {
            debugPrint(error.localizedDescription)
            self.error(.failedToUpdateQuizRecord)
        }
    }
    
    private func addCountryQuizStat(userId: String) async {
        do {
            let result = quiz.getQuizRoundResult(by: nil)
            try await  container.services.countryQuizStatService.updateCountryQuizStats(
                userId: userId,
                addingCodes: result.correct,
                substractingCodes: result.wrong
            )
        } catch {
            debugPrint(error.localizedDescription)
            self.error(.failedToUpdateCountryQuizStat)
        }
    }
    
    private func updateEarthCandy(userId: String) {
        let earthCandy = FQEarthCandy.calculatePoint(from: quiz, ofUser: userId)
        container.services.earthCandyService.updateCandy(earthCandy.point, ofUser: userId)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    debugPrint(error.localizedDescription)
                    self?.error(.failedToUpdateEarthCandy)
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
    
    private func error(_ quizError: QuizError) {
        //TODO: Error 핸들링
    }
}
