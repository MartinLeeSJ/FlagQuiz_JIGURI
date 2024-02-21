//
//  NavigationModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI
import Combine

protocol NavigationModelInterface {
    var destinations: NavigationPath { get set }
    var objectWillChange: ObservableObjectPublisher? { get set }
    
    func navigate(to destination: any Hashable)
    func pop()
    func toRoot()
    
    func setObjectWillChange(_ objectWillChage: ObservableObjectPublisher)
}

final class NavigationModel: NavigationModelInterface {
    var destinations: NavigationPath = .init() {
        didSet {
            objectWillChange?.send()
        }
    }
    
    var objectWillChange: ObservableObjectPublisher?
    
    public func navigate(to destination: any Hashable) {
        destinations.append(destination)
    }
    
    public func pop() {
       destinations.removeLast()
    }
    
    public func toRoot() {
        destinations = .init()
    }
    
    public func setObjectWillChange(_ objectWillChage: ObservableObjectPublisher) {
        self.objectWillChange = objectWillChage
    }
}
