//
//  FQQuizDifficulty.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/27/24.
//

import SwiftUI

enum FQQuizDifficulty: Int {
    case easy = 1
    case medium
    case hard
    case extreme
    
    var color: Color {
        switch self {
        case .easy: .green
        case .medium: .yellow
        case .hard: .red
        case .extreme: .purple
        }
    }
}
