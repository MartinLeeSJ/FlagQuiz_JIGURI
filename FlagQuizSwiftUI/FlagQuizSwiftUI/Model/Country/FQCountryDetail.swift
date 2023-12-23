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


extension FQCountryDetail {
    private init(
        id: FQCountryISOCode,
        name: FQCountryName,
        capitals: [String]?,
        coordinates: [Double],
        languages: [String],
        mapsLinks: FQMapsLinks,
        area: Double,
        population: Int,
        borderedCountries: [String]?,
        timezones: [String],
        continents: [FQContinent],
        flagLinks: FQFlagLinks
    ) {
        self.id = id
        self.name = name
        self.capitals = capitals
        self.coordinates = coordinates
        self.languages = languages
        self.mapsLinks = mapsLinks
        self.area = area
        self.population = population
        self.borderedCountries = borderedCountries
        self.timezones = timezones
        self.continents = continents
        self.flagLinks = flagLinks
        
    }
    
    static let mock: FQCountryDetail = .init(
        id: .init("170"),
        name: .init(
            common: "chadchadchadchadchad",
            official: "The Republic of Mockland"
        ),
        capitals: ["mokeoul"],
        coordinates: [100, 33],
        languages: ["mocklish"],
        mapsLinks: .init(googleMaps: "", openStreetMaps: ""),
        area: 111111,
        population: 111111,
        borderedCountries: ["fakeland", "fantasyland"],
        timezones: ["UTF +4.0"],
        continents: [.init(rawValue: "Asia")!],
        flagLinks: .init(png: "", svg: "https://flagcdn.com/co.svg", alt: "")
    )
}
