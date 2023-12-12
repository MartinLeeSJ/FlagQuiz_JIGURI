//
//  Constant.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

enum Constant {}

typealias CollectionKey = Constant.CollectionKey
typealias LocalizableTable = Constant.LocalizableTable

extension Constant {
    struct CollectionKey {
        static let Users: String = "Users"
    }
    
    struct LocalizableTable {
        static let button: String = "ButtonLocalizable"
    }
}
