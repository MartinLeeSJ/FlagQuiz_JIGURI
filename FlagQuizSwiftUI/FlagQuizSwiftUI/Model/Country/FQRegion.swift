//
//  FQRegion.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/13/24.
//

import Foundation

enum FQRegion: String, Codable {
    case americas = "Americas"
    case antartica = "Antarctic"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
    
    var localizedName: String {
        switch self {
        case .americas: 
            String(
                localized: "fqRegion.americas",
                defaultValue: "Americas"
            )
        case .antartica:
            String(
                localized: "fqRegion.antartica",
                defaultValue: "Antarctic"
            )
        case .asia:
            String(
                localized: "fqRegion.asia",
                defaultValue: "Asia"
            )
        case .europe:
            String(
                localized: "fqRegion.europe",
                defaultValue: "Europe"
            )
            
        case .oceania:
            String(
                localized: "fqRegion.oceania",
                defaultValue: "Oceania"
            )
        }
    }
}
