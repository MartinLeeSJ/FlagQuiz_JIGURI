//
//  FQItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItem: FQItemProtocol {
    let id: String
    let type: FQItemType
    let stockName: String
    var names: [FQItemName]
    var price: Int
    var specialPrice: Int
    var isOnEvent: Bool
    var isOnMarket: Bool
    
    func storageImagePath(equipped: Bool) -> String {
        "\(StoragePath.items)/\(type.rawValue)/\(stockName)/\(equipped ? "item_equipped" : "item").png"
    }
}

extension FQItem: Codable, Identifiable, Hashable {}



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
    
    func toUserItem() -> FQUserItem {
        .init(
            id: id,
            type: type,
            stockName: stockName,
            purchasedAt: .now,
            purchasedPrice: isOnEvent ? specialPrice : price
        )
    }
}


