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
    var name: String
}

extension FQItemObject {
    func toModel() -> FQItem? {
        guard let type = FQItemType(rawValue: type) else {
            return nil
        }
        
        return .init(id: id, type: type, name: name)
    }
}
