//
//  CountryData.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/9/26.
//

import Foundation
import SwiftData

@Model
class CountryData {
    @Attribute(.unique) var id: Int
    
    // country_rows
    var cca3: String
    var nameCommon: String
    var nameOfficial: String
    var region: String
    var lat: Double
    var lng: Double
    var area: Int
    var population: Int
    
    // country_timezone_rows
    var timezone: [String]
    
    // country_map_rows
    var googleMapUrl: String
    var openstreetMapUrl: String
    
    // country_flag_rows
    var pngFlagUrl: String
    var svgFlagUrl: String
    var flagAlt: String
    
    // country_currency_rows
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    
    // country_continent_rows
    var continents: [String]
    
    // country_capital_kr_rows
    var capitalsKr: [String]
    
    // country_capital_info_rows
    var capitalLat: Double
    var capitalLong: Double
    
    // country_border_rows
    var neighborIds: [Int]
    
    init(
        id: Int,
        cca3: String,
        nameCommon: String,
        nameOfficial: String,
        region: String,
        lat: Double,
        lng: Double,
        area: Int,
        population: Int,
        timezone: [String],
        googleMapUrl: String,
        openstreetMapUrl: String,
        pngFlagUrl: String,
        svgFlagUrl: String,
        flagAlt: String,
        currencyCode: String,
        currencyName: String,
        currencySymbol: String,
        continents: [String],
        capitalsKr: [String],
        capitalLat: Double,
        capitalLong: Double,
        neighborIds: [Int]
    ) {
        self.id = id
        self.cca3 = cca3
        self.nameCommon = nameCommon
        self.nameOfficial = nameOfficial
        self.region = region
        self.lat = lat
        self.lng = lng
        self.area = area
        self.population = population
        self.timezone = timezone
        self.googleMapUrl = googleMapUrl
        self.openstreetMapUrl = openstreetMapUrl
        self.pngFlagUrl = pngFlagUrl
        self.svgFlagUrl = svgFlagUrl
        self.flagAlt = flagAlt
        self.currencyCode = currencyCode
        self.currencyName = currencyName
        self.currencySymbol = currencySymbol
        self.continents = continents
        self.capitalsKr = capitalsKr
        self.capitalLat = capitalLat
        self.capitalLong = capitalLong
        self.neighborIds = neighborIds
    }
}
