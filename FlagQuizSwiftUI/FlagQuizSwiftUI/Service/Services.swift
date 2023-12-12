//
//  Services.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

protocol ServiceType {
    var authService: AuthServiceType { get set }
}

class Services: ServiceType {
    var authService: AuthServiceType
    
    init() {
        self.authService = AuthService()
    }
}

class StubService: ServiceType {
    var authService: AuthServiceType
    
    init() {
        self.authService = StubAuthService()
    }
}
