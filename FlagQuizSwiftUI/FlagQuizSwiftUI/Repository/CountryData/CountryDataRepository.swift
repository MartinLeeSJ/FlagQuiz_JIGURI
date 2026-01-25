//
//  CountryDataRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/2/26.
//

import Foundation
import TabularData
import SwiftData

public protocol CountryDataRepository {
    func loadCountries() async throws -> [Int: CountryData]
}

public actor CountryDataRepositoryImpl: CountryDataRepository {
    private var data: [Int: CountryData] = [:]
    public func loadCountries() throws -> [Int: CountryData]{
        try CountryCSVFileName.allCases.forEach { name in
            guard let fileUrl = name.fileURL else { return }
            let dataFrame = try DataFrame(contentsOfCSVFile: fileUrl, columns: name.csvMetadata.columns, types: name.csvMetadata.types)
            switch name {
            case .base: makeDatafromCountryRow(dataFrame)
            case .border: makeDataFromBorderRows(dataFrame)
            case .capital: makeDataFromCapitalInfoRows(dataFrame)
            case .capitalKr: makeDataFromCapitalKrRows(dataFrame)
            case .continent: makeDataFromContinentRows(dataFrame)
            case .currency: makeDataFromCurrencyRows(dataFrame)
            case .flag: makeDataFromFlagRows(dataFrame)
            case .map: makeDataFromMapRows(dataFrame)
            case .timezone: makeDataFromTimeZoneRow(dataFrame)
            }
        }
        
        return data
    }
    
    private func makeDatafromCountryRow(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int {
               let countryData = data[id, default: .init(id: id)]
                countryData.cca3 = row["cca3"] as? String
                countryData.nameCommon = row["name_common"] as? String
                countryData.nameOfficial = row["name_official"] as? String
                countryData.region = row["region"] as? String
                countryData.lat = row["lat"] as? Double
                countryData.lng = row["lng"] as? Double
                countryData.area = Int(row["area"] as? Double ?? .zero)
                countryData.population = row["population"] as? Int
            }
        }
    }
    
    private func makeDataFromTimeZoneRow(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int,
               let timezone = row["timezone"] as? String {
                let countryData = data[id, default: .init(id: id)]
                countryData.timezone.append(timezone)
            }
        }
    }
    
    private func makeDataFromMapRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int,
               let googleMapsUrl = row["google_maps_url"] as? String,
               let openStreetMapsUrl = row["openstreetmaps_url"] as? String {
                let countryData = data[id, default: .init(id: id)]
                countryData.googleMapUrl = googleMapsUrl
                countryData.openstreetMapUrl = openStreetMapsUrl
            }
        }
    }
    
    private func makeDataFromFlagRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int {
                let countryData = data[id, default: .init(id: id)]
                countryData.pngFlagUrl = row["png_url"] as? String
                countryData.svgFlagUrl = row["svg_url"] as? String
                countryData.flagAlt = row["alt"] as? String
            }
        }
    }
    
    private func makeDataFromCurrencyRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int {
                let countryData = data[id, default: .init(id: id)]
                countryData.currencyCode = row["currency_code"] as? String
                countryData.currencyName = row["name"] as? String
                countryData.currencySymbol = row["symbol"] as? String
            }
        }
    }
    
    private func makeDataFromContinentRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int,
               let continent = row["continent"] as? String {
                let countryData = data[id, default: .init(id: id)]
                countryData.continents.append(continent)
            }
        }
    }
    
    private func makeDataFromCapitalKrRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int,
               let capitalKr = row["capital_kr"] as? String {
                let countryData = data[id, default: .init(id: id)]
                countryData.capitalsKr.append(capitalKr)
            }
        }
    }
    
    private func makeDataFromCapitalInfoRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int {
                let countryData = data[id, default: .init(id: id)]
                countryData.capitalLat = row["lat"] as? Double
                countryData.capitalLat = row["lng"] as? Double
            }
        }
    }
    
    private func makeDataFromBorderRows(_ dataFrame: DataFrame) {
        dataFrame.rows.forEach { row in
            if let id = row["id"] as? Int,
               let neighborId = row["neighbor_id"] as? Int {
                let countryData = data[id, default: .init(id: id)]
                countryData.neighborIds.append(neighborId)
                
            }
        }
    }
    
    
}

enum CountryCSVFileName: String, CaseIterable {
    case base = ""
    case border
    case capital = "capital_info"
    case capitalKr = "capital_kr"
    case continent
    case currency
    case flag
    case map
    case timezone
    
    var fileName: String {
        "country_" + self.rawValue + "\(self == .base ? "" : "_")rows"
    }
    
    var fileURL: URL? {
        if let url = Bundle.main.url(forResource: self.fileName, withExtension: "csv") {
            return url
        }
        return nil
    }
    
    var csvMetadata: (columns: [String], types: [String: CSVType]) {
        switch self {
        case .border: (CountryBorderRows.allColumns, CountryBorderRows.csvTypes)
        case .capital: (CountryCapitalInfoRows.allColumns, CountryCapitalInfoRows.csvTypes)
        case .capitalKr: (CountryCapitalKrRows.allColumns, CountryCapitalKrRows.csvTypes)
        case .continent: (CountryContinentRows.allColumns, CountryContinentRows.csvTypes)
        case .currency: (CountryCurrencyRows.allColumns, CountryCurrencyRows.csvTypes)
        case .flag: (CountryFlagRows.allColumns, CountryFlagRows.csvTypes)
        case .map: (CountryMapRows.allColumns, CountryMapRows.csvTypes)
        case .base: (CountryRows.allColumns, CountryRows.csvTypes)
        case .timezone: (CountryTimezoneRows.allColumns, CountryTimezoneRows.csvTypes)
        }
    }
    
}

protocol CountryCSVData: CaseIterable, RawRepresentable where RawValue == String {
    var csvType: CSVType { get }
    static var allColumns: [String] { get }

}

extension CountryCSVData {
    static var csvTypes: [String: CSVType] {
        Self.allCases.reduce(into: [String: CSVType]()) { partialResult, key in
            return partialResult[key.rawValue] = key.csvType
        }
    }
    
    static var allColumns: [String] {
        Self.allCases.map { $0.rawValue }
    }
}

enum CountryRows: String, CountryCSVData  {
    case id
    case cca3
    case nameCommon = "name_common"
    case nameOfficial = "name_official"
    case region
    case lat
    case lng
    case area
    case population

    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .cca3: .string
        case .nameCommon: .string
        case .nameOfficial: .string
        case .region: .string
        case .lat: .double
        case .lng: .double
        case .area: .double
        case .population: .integer
        }
    }
}

enum CountryTimezoneRows: String, CountryCSVData {
    case id = "country_id"
    case timezone
    
    var csvType: CSVType {
        switch self {
        case .id:
                .integer
        case .timezone:
                .string
        }
    }
 }

enum CountryMapRows: String, CountryCSVData {
    case id = "country_id"
    case googleMapsUrl = "google_maps_url"
    case openStreetMapsUrl = "openstreetmaps_url"
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .googleMapsUrl: .string
        case .openStreetMapsUrl: .string
        }
    }
}

enum CountryFlagRows: String, CountryCSVData {
    case id = "country_id"
    case pngUrl = "png_url"
    case svgUrl = "svg_url"
    case alt
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .pngUrl: .string
        case .svgUrl: .string
        case .alt: .string
        }
    }
}

enum CountryCurrencyRows: String, CountryCSVData {
    case id = "country_id"
    case currencyCode = "currency_code"
    case name
    case symbol
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .currencyCode: .string
        case .name: .string
        case .symbol: .string
        }
    }
}

enum CountryContinentRows: String, CountryCSVData {
    case id = "country_id"
    case continent
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .continent: .string
        }
    }
}

enum CountryCapitalKrRows: String, CountryCSVData {
    case id = "country_id"
    case capitalKr = "capital_kr"
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .capitalKr: .string
        }
    }
}

enum CountryCapitalInfoRows: String, CountryCSVData {
    case id = "country_id"
    case lat
    case lng
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .lat: .double
        case .lng: .double
        }
    }
}

enum CountryBorderRows: String, CountryCSVData {
    case id = "country_id"
    case neighborId = "neighbor_id"
    
    var csvType: CSVType {
        switch self {
        case .id: .integer
        case .neighborId: .integer
        }
    }
}



