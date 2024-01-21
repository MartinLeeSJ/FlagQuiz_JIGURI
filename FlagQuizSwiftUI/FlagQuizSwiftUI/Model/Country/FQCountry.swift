//
//  FQCountry.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

protocol FQCountryRenderer {
    var id: FQCountryISOCode { get }
    var name: FQCountryName { get }
    var flagLinks: FQFlagLinks { get }
    var continents: [FQContinent] { get }
    var capitals: [String]? { get }
}

struct FQCountry: FQCountryRenderer, Codable {
    let id: FQCountryISOCode
    let name: FQCountryName
    let flagLinks: FQFlagLinks
    let continents: [FQContinent]
    let capitals: [String]?
    
}






