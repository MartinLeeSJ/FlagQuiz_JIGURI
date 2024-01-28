//
//  FQItemName.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItemName: Codable {
    var languageCode: ServiceLangCode
    var name: String    
}

extension FQItemName {
    func toObject() -> FQItemNameObject {
        .init(
            identifier: languageCode.rawValue,
            name: name
        )
    }
}

