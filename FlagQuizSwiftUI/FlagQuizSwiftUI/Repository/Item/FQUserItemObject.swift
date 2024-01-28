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
    var itemTypeName: String
    var purchasedAt: Timestamp
}

extension FQUserItemObject {
    func toModel() -> FQUserItem? {
        guard let itemId else { return nil }
        guard let itemType = FQItemType(rawValue: itemTypeName) else { return nil }
        
        return .init(
            itemId: itemId,
            itemType: itemType,
            purchasedAt: purchasedAt.dateValue()
        )
    }
}


extension FQUserItemObject {
    func nilIdObject() -> FQUserItemObject {
        .init(
            itemId: nil,
            itemTypeName: itemTypeName,
            purchasedAt: purchasedAt
        )
    }
}
