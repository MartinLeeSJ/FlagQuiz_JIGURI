//
//  FQItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItem: Codable {
    var id: String
    var type: FQItemType
    var code: String
    var names: [FQItemName]
    var isOnMarket: Bool
    var imageUrl: String?
    var storeImageUrl: String?
}



extension FQItem {
    func toObject() -> FQItemObject {
        .init(
            id: id,
            type: type.rawValue,
            code: code,
            names: names.map { $0.toObject() },
            isOnMarket: isOnMarket,
            imageUrl: imageUrl,
            storeImageUrl: storeImageUrl
        )
    }
}


