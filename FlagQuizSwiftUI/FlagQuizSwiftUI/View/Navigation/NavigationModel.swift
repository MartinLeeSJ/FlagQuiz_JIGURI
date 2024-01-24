//
//  NavigationModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

final class NavigationModel: ObservableObject {
    @Published var destinations: NavigationPath = .init()
    
    public func navigate(to destination: any Hashable) {
        destinations.append(destination)
    }
    
    public func pop() {
       destinations.removeLast()
    }
    
    public func toRoot() {
        destinations = .init()
    }
}
