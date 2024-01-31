//
//  FQUserItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation

/// 유저가 가지고 있는 아이템
struct FQUserItem {
    var itemId: String
    var itemType: FQItemType
    var purchasedAt: Date
}

extension FQUserItem: Identifiable {
    var id: String { itemId }
}

extension FQUserItem {
    func toObject() -> FQUserItemObject {
        .init(
            itemId: itemId,
            itemTypeName: itemType.rawValue,
            purchasedAt: .init(date: purchasedAt),
            itemReference: FQUserItemObject.makeDocumentReference(with: itemId)
        )
    }
}
