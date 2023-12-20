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


