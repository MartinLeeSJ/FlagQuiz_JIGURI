//
//  FQItemName.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItemName: Codable {
    var identifier: ServiceLangCode
    var name: String    
}

extension FQItemName {
    func toObject() -> FQItemNameObject {
        .init(
            identifier: identifier.rawValue,
            name: name
        )
    }
}

