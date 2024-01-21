//
//  FQContinent.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import Foundation

enum FQContinent: String, Codable {
    case asia = "Asia"
    case europe = "Europe"
    case northAmerica = "North America"
    case southAmerica = "South America"
    case africa = "Africa"
    case oceania = "Oceania"
    case antartica = "Antartica"
    case none = "None"
    
    var colorName: String {
        switch self {
        case .northAmerica: "FQNorthAmerica"
        case .southAmerica: "FQSouthAmerica"
        case .none:  ".systemGray"
        default: "FQ\(self.rawValue)"
        }
    }
    
    var localizedName: String {
        switch self {
        case .northAmerica: return String(localized: "N. America")
        case .southAmerica: return String(localized: "S. America")
        default:
            let string = String.LocalizationValue(stringLiteral: self.rawValue)
            return String(localized: string)
        }
    }
}
