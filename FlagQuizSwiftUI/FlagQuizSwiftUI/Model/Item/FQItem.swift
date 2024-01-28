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
    var names: [FQItemName]
    var price: Int
    var isOnMarket: Bool
    var imageUrl: String?
    var storeImageUrl: String?
}



extension FQItem {
    func toObject() -> FQItemObject {
        .init(
            id: id,
            type: type.rawValue,
            names: names.map { $0.toObject() },
            price: price,
            isOnMarket: isOnMarket,
            imageUrl: imageUrl,
            storeImageUrl: storeImageUrl
        )
    }
}


