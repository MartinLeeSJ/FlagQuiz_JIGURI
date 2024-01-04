//
//  FQItem.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

struct FQItem {
    var id: String
    var type: FQItemType
    var name: String
}

enum FQItemType: String, Hashable {
    case hat
    case hair
    case top
    case bottom
    case shoes
    case rightHandAccesory
    case leftHandAccesory
    case background
    case skin
}
