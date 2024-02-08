//
//  FQUserItemObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation
import FirebaseFirestore

struct FQUserItemObject: Codable {
    @DocumentID var itemId: String?
    let itemTypeName: String
    let stockName: String
    let purchasedAt: Timestamp
    let purchasedPrice: Int
    
}

extension FQUserItemObject {
    func toModel() -> FQUserItem? {
        guard let itemId else { return nil }
        guard let itemType = FQItemType(rawValue: itemTypeName) else { return nil }

        return .init(
            id: itemId,
            type: itemType,
            stockName: stockName,
            purchasedAt: purchasedAt.dateValue(),
            purchasedPrice: purchasedPrice
        )
    }
}


extension FQUserItemObject {
    func nilIdObject() -> FQUserItemObject {
        .init(
            itemId: nil,
            itemTypeName: itemTypeName,
            stockName: stockName,
            purchasedAt: purchasedAt,
            purchasedPrice: purchasedPrice
        )
    }
}
