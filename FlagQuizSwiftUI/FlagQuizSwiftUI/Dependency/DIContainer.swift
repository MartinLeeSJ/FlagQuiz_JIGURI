//
//  DIContainer.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

final class DIContainer: ObservableObject {
    public var services: ServiceType
    public var navigationModel: NavigationModelInterface
    
    init(
        services: ServiceType,
        navigationModel: NavigationModelInterface = NavigationModel()
    ) {
        self.services = services
        self.navigationModel = navigationModel
        
        navigationModel.setObjectWillChange(objectWillChange)
    }
}
