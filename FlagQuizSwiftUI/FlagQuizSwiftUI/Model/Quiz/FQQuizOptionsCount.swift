//
//  FQQuizItemCount.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/18/24.
//

import Foundation

enum FQQuizOptionsCount: Int, CaseIterable {
    case three = 3
    case four = 4
    case five = 5
    
    var advantageCandy: Int {
        switch self {
        case .three: 0
        case .four: 1
        case .five: 2
        }
    }
}
