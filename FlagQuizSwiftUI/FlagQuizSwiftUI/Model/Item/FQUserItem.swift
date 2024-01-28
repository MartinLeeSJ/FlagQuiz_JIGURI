//
//  FQUserItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import Foundation

struct FQUserItem {
    var itemId: String
    var itemType: FQItemType
    var purchasedAt: Date
}

extension FQUserItem: Identifiable {
    var id: String { itemId }
}
