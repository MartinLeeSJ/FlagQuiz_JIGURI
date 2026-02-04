//
//  CountryData.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/9/26.
//

import Foundation
import SwiftData

//language -> currency
@Model
public final class CountryData: Sendable {
    @Attribute(.unique) public var id: Int
    
    // country_rows
    public var cca3: String?
    public var nameCommon: String?
    public var nameOfficial: String?
    public var region: String?
    public var lat: Double?
    public var lng: Double?
    public var area: Int?
    public var population: Int?
    
    // country_timezone_rows
    public var timezone: [String]
    
    // country_map_rows
    public var googleMapUrl: String?
    public var openstreetMapUrl: String?
    
    // country_flag_rows
    public var pngFlagUrl: String?
    public var svgFlagUrl: String?
    public var flagAlt: String?
    
    // country_currency_rows
    public var currencyCode: String?
    public var currencyName: String?
    public var currencySymbol: String?
    
    // country_continent_rows
    public var continents: [String]
    
    // country_capital_rows
    public var capitals: [String]
    // country_capital_kr_rows
    public var capitalsKr: [String]
    
    // country_capital_info_rows
    public var capitalLat: Double?
    public var capitalLong: Double?
    
    // country_border_rows
    public var neighborIds: [Int]
    
    public init(
        id: Int,
        cca3: String? = nil,
        nameCommon: String? = nil,
        nameOfficial: String? = nil,
        region: String? = nil,
        lat: Double? = nil,
        lng: Double? = nil,
        area: Int? = nil,
        population: Int? = nil,
        timezone: [String] = [],
        googleMapUrl: String? = nil,
        openstreetMapUrl: String? = nil,
        pngFlagUrl: String? = nil,
        svgFlagUrl: String? = nil,
        flagAlt: String? = nil,
        currencyCode: String? = nil,
        currencyName: String? = nil,
        currencySymbol: String? = nil,
        continents: [String] = [],
        capitals: [String] = [],
        capitalsKr: [String] = [],
        capitalLat: Double? = nil,
        capitalLong: Double? = nil,
        neighborIds: [Int] = []
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
        self.capitals = capitals
        self.capitalsKr = capitalsKr
        self.capitalLat = capitalLat
        self.capitalLong = capitalLong
        self.neighborIds = neighborIds
    }
}
