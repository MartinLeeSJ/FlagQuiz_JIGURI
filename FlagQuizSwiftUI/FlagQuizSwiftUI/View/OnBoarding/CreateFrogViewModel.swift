//
//  CreateFrogViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/16/24.
//

import SwiftUI
import Combine

final class CreateFrogViewModel: ObservableObject {
    @Published var selectedCode: FQCountryISOCode?
    @Published var query: String = ""
    @Published var didCreateFrog: Bool = false
    
    enum Action {
        case selectCountry(FQCountryISOCode)
        case selectRandomCountry
        case submit
    }
    
    public var countryCodes: [FQCountryISOCode] {
        guard !query.isEmpty else {
            return FQCountryISOCode.safeAllCodes
        }
        
        return FQCountryISOCode.safeAllCodes.filter {
            guard let name = $0.localizedName else {
                return false
            }
            
            return name.localizedCaseInsensitiveContains(query)
        }
    }
    
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    init(container: DIContainer) {
        self.container = container
    }
    
    public func send(_ action: Action) {
        switch action {
        case .selectCountry(let code):
            selectedCode = code
            query = ""
        case .selectRandomCountry:
            selectRandomCountry()
        case .submit:
            //TODO: -
            submitCountry()
        }
    }
    
    func selectRandomCountry() {
        selectedCode = FQCountryISOCode.randomCode(of: 1, except: nil).first
        query = ""
    }
    
    func submitCountry() {
        guard let selectedCode else { return }
        guard let userId = container.services.authService.checkAuthenticationState() else {
            return
            //TODO: Error Handling
        }
        
        let newFrog: FQFrog = .init(
            userId: userId,
            state: .good,
            lastUpdated: .now,
            items: [],
            nation: selectedCode
        )
        
        container.services.frogService.addFrog(newFrog, ofUser: userId)
            .sink { [weak self] completion in
                if case .finished = completion {
                    self?.didCreateFrog = true
                }
            } receiveValue: { _ in
                
            }
            .store(in: &cancellables)
    }
}
