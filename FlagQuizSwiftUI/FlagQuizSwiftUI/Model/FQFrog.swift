//
//  FQFrog.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import FirebaseFirestore

struct FQFrog: Identifiable {
    var id: String {
        userId
    }
    var userId: String
    var status: FrogState
    var lastUpdated: Date
    var item: [FQItem]
}

extension FQFrog {
    func toObject() -> FQFrogObject {
        .init(
            id: userId,
            status: status.rawValue,
            lastUpdated: .init(date: lastUpdated),
            item: item.map { $0.toObject() }
        )
    }
}


enum FrogState: Int {
    case bad = 0
    case soso = 1
    case good = 2
    case great = 3
    
    static func safeValue(rawValue: Int) -> FrogState {
        var value: Int = rawValue
        value = max(self.bad.rawValue, value)
        value = min(self.great.rawValue, value)
        
        return FrogState(rawValue: value)!
    }
}
