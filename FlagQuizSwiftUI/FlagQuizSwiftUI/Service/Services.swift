//
//  Services.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

protocol ServiceType {
    var authService: AuthServiceType { get set }
    var userService: UserServiceType { get set }
    var quizService: QuizServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthServiceType
    var userService: UserServiceType
    var quizService: QuizServiceType
    
    init() {
        self.authService = AuthService()
        self.userService = UserService(repository: .init())
        self.quizService = QuizService()
    }
}

class StubService: ServiceType {
    var authService: AuthServiceType
    var userService: UserServiceType
    var quizService: QuizServiceType
    
    init() {
        self.authService = StubAuthService()
        self.userService = StubUserService()
        self.quizService = StubQuizService()
    }
}
