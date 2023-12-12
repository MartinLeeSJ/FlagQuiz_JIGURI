//
//  DIContainer.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

final class DIContainer: ObservableObject {
    public var services: ServiceType
    
    init(services: ServiceType) {
        self.services = services
    }
}
