//
//  FQCountryDetail.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import Foundation

struct FQCountryDetail: FQCountryRenderer, Codable {
    let id: FQCountryISOCode
    let name: FQCountryName
    let capitals: [String]?
    let coordinates: [Double]
    let languages: [String]
    let mapsLinks: FQMapsLinks
    let area: Double
    let population: Int
    let borderedCountries: [String]?
    let timezones: [String]
    let continents: [FQContinent]
    let flagLinks: FQFlagLinks
    
    enum CodingKeys: String, CodingKey {
        case id = "ccn3"
        case name
        case capitals = "capital"
        case coordinates = "latlng"
        case languages
        case mapsLinks = "maps"
        case area
        case population
        case borderedCountries = "borders"
        case timezones
        case continents
        case flagLinks = "flags"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let ccn3: String = try container.decode(String.self, forKey: .id)
        self.id = FQCountryISOCode(ccn3)
        
        self.name = try container.decode(FQCountryName.self, forKey: .name)
        self.capitals = try container.decodeIfPresent([String].self, forKey: .capitals)
        self.coordinates = try container.decode([Double].self, forKey: .coordinates)
        
        let languages = try container.decode([String:String].self, forKey: .languages)
        self.languages = Array(languages.values)
        
        self.mapsLinks = try container.decode(FQMapsLinks.self, forKey: .mapsLinks)
        self.area = try container.decode(Double.self, forKey: .area)
        self.population = try container.decode(Int.self, forKey: .population)
        self.borderedCountries = try container.decodeIfPresent([String].self, forKey: .borderedCountries)
        self.timezones = try container.decode([String].self, forKey: .timezones)
        
        let continents: [String] = try container.decode([String].self, forKey: .continents)
        self.continents = continents.compactMap { FQContinent(rawValue: $0) }
        
        self.flagLinks = try container.decode(FQFlagLinks.self, forKey: .flagLinks)
    }
}


