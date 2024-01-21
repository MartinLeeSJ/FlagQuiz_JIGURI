//
//  CountryObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

struct CountryObject: Codable {
    let ccn3: String
    let name: CountryName
    let capital: [String]?
    let latlng: [Double]
    let languages: [String:String]
    let maps: [String:String]
    let area: Double
    let population: Int
    let borders: [String]?
    let gini: [String : Double]?
    let timezones: [String]
    let continents: [String]
    let flags: [String:String]
}

extension CountryObject {
    struct CountryName: Codable {
        let common: String
        let official: String
    }
}

extension CountryObject {
    func toCountryModel() -> FQCountry {
        .init(
            id: .init(ccn3),
            name: .init(common: name.common, official: name.official),
            flagLinks: .init(png: flags["png"], svg: flags["svg"], alt: flags["alt"]),
            continents: continents.compactMap { .init(rawValue: $0) },
            capitals: capital
        )
    }
    
    func toCountryDetailModel() -> FQCountryDetail {
        .init(
            id: .init(ccn3),
            name: .init(common: name.common, official: name.official),
            capitals: capital,
            coordinates: latlng,
            languages: Array(languages.values),
            mapsLinks: .init(
                googleMaps: maps["googleMaps"] ?? "",
                openStreetMaps: maps["openStreetMaps"] ?? ""
            ),
            area: area,
            population: population,
            borderedCountries: borders,
            timezones: timezones,
            continents: continents.compactMap { .init(rawValue: $0) },
            flagLinks: .init(png: flags["png"], svg: flags["svg"], alt: flags["alt"])
        )
    }
    
    
}


