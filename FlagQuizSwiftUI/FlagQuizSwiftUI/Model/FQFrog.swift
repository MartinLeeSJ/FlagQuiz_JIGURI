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
    var state: FrogState
    
    /// 상태가 마지막으로 업데이트 된 시점
    var lastUpdated: Date
    
    /// 장착하고있는 item Id
    var items: [String]
}

extension FQFrog {
    func toObject() -> FQFrogObject {
        .init(
            id: userId,
            status: state.rawValue,
            lastUpdated: .init(date: lastUpdated),
            items: items
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
    
    mutating func upgrade()  {
        self = Self.safeValue(rawValue: self.rawValue + 1)
    }
    
    var frogImageName: String {
        switch self {
        case .bad:
            "frogBad"
        case .soso:
            "frogSoSo"
        case .good:
            "frogGood"
        case .great:
            "frogGreat"
        }
    }
    
    var feedFrogButtonTitle: String {
        switch self {
        case .bad:
            String(localized: "feed.frog.button.title.state.bad")
        case .soso:
            String(localized: "feed.frog.button.title.state.soso")
        case .good:
            String(localized: "feed.frog.button.title.state.good")
        case .great:
            String(localized: "feed.frog.button.title.state.great")
        }
    }
}
