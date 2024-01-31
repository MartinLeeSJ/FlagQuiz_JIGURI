//
//  FQItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItem: Codable, Identifiable, Hashable {
    var id: String
    var type: FQItemType
    var stockName: String
    var names: [FQItemName]
    var price: Int
    var specialPrice: Int
    var isOnEvent: Bool
    var isOnMarket: Bool
}



extension FQItem {
    func toObject() -> FQItemObject {
        .init(
            id: id,
            type: type.rawValue,
            stockName: stockName,
            names: names.map { $0.toObject() },
            price: price,
            specialPrice: specialPrice,
            isOnEvent: isOnEvent,
            isOnMarket: isOnMarket
        )
    }
}


