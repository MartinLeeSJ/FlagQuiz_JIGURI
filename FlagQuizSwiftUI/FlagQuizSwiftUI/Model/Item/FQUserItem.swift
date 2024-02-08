//
//  FQUserItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation

/// 유저가 가지고 있는 아이템
struct FQUserItem: Identifiable, FQItemProtocol {
    let id: String
    let type: FQItemType
    let stockName: String
    let purchasedAt: Date
    let purchasedPrice: Int
    
    func storageImagePath(equipped: Bool) -> String {
        "\(StoragePath.items)/\(type.rawValue)/\(stockName)/\(equipped ? "item_equipped" : "item").png"
    }
}

extension FQUserItem: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension FQUserItem {
    func toObject() -> FQUserItemObject {
        .init(
            itemId: id,
            itemTypeName: type.rawValue,
            stockName: stockName,
            purchasedAt: .init(date: purchasedAt),
            purchasedPrice: purchasedPrice
        )
    }
}
