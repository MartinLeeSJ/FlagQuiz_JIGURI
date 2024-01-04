//
//  FQItemObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItemObject: Codable {
    var id: String
    var type: String
    var code: String
    var names: [FQItemNameObject]
    var isOnMarket: Bool
}

extension FQItemObject {
    func toModel() -> FQItem? {
        guard let type = FQItemType(rawValue: type) else {
            return nil
        } 
        
        return .init(
            id: id,
            type: type,
            code: code,
            names: names.map { $0.toModel() },
            isOnMarket: isOnMarket
        )
    }
}
