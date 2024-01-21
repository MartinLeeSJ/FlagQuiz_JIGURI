//
//  FQItemNameObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItemNameObject: Codable {
    var identifier: String
    var name: String
}

extension FQItemNameObject {
    func toModel() -> FQItemName {
        let code = ServiceLangCode(rawValue: identifier) ?? .EN
        return .init(
            identifier: code,
            name: name
        )
    }
}
