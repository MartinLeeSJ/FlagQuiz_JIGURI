//
//  FQItemType.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation

enum FQItemType: String, Hashable, Codable, CaseIterable {
    case hair
    case hat
    case top
    case bottom
    case overall
    case accessory
    case gloves
    case shoes
    case background
    case faceDeco
    case set
    
    var localizedName: String {
        switch self {
        case .hair: String(localized:"fQItemType.hair", defaultValue: "HairStyles")
        case .hat: String(localized:"fQItemType.hat", defaultValue: "Hats")
        case .top: String(localized:"fQItemType.top", defaultValue: "Tops")
        case .bottom:  String(localized:"fQItemType.bottom", defaultValue: "Bottoms")
        case .overall:  String(localized:"fQItemType.overall", defaultValue: "Overalls")
        case .accessory: String(localized:"fQItemType.accessory", defaultValue: "Accessories")
        case .gloves: String(localized:"fQItemType.gloves", defaultValue: "Gloves")
        case .shoes: String(localized:"fQItemType.shoes", defaultValue: "Shoes")
        case .background: String(localized:"fQItemType.background", defaultValue: "Backgrounds")
        case .faceDeco: String(localized:"fQItemType.faceDeco", defaultValue: "Face Decorations")
        case .set: String(localized:"fQItemType.set", defaultValue: "Sets")
        }
    }
}
