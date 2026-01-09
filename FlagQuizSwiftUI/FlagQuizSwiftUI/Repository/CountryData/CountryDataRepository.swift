//
//  CountryDataRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/2/26.
//

import Foundation
import SwiftCSV
import TabularData

public protocol CountryDataRepository {
    func getDataFromCSV() async throws -> [String]
}

public actor CountryDataRepositoryImpl: CountryDataRepository {
    public func getDataFromCSV() async throws -> [String] {
    try getCountryRow()
    return []
    }
    
    func getCountryRow() throws {
//        guard let url = CountryRows.fileURL else { throw URLError(.badURL) }
//        let dataFrame = try DataFrame(contentsOfCSVFile: url, columns: CountryRows.columns, types: CountryRows.csvTypes)
//        let _ = dataFrame.rows.map { row in
//            print(row.description)
//        }
    }
}

enum CountryCSVFileName: String, CaseIterable {
    case border
    case capital = "capital_info"
    case capitalKr = "capital_kr"
    case continent
    case currency
    case flag
    case map
    case base = ""
    case timezone
    
    var fileName: String {
        "country_" + self.rawValue + "\(self == .base ? "" : "_")rows"
    }
    
    var fileURL: URL? {
        if let filePath = Bundle.main.path(forResource: self.fileName, ofType: "csv"),
           let url = URL(string: filePath) {
            return url
        }
        return nil
    }
    
    func countryCSVData<T: CountryCSVData>() -> T.Type? {
        switch self {
        default: CountryRows.self as? T.Type
        }
    }
    
    
}

protocol CountryCSVData {
    static var csvTypes: [String: CSVType] { get }
}

enum CountryRows: String, CaseIterable, CountryCSVData  {
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
    
    static var csvTypes: [String: CSVType] {
        Self.allCases.reduce(into: [String:CSVType]()) { partialResult, row in
            partialResult[row.rawValue] = row.csvType
        }
    }
}

enum CountryTimezoneRows: String, CaseIterable, CountryCSVData {
    case countryId = "country_id"
    case timezone
    
    private var csvType: CSVType {
        switch self {
        case .countryId:
                .integer
        case .timezone:
                .string
        }
    }
    
    static var csvTypes: [String: CSVType] {
        Self.allCases.reduce(into: [String: CSVType]()) { partialResult, key in
            partialResult[key.rawValue] = key.csvType
        }
    }
 }

enum CountryMapRows: String, CaseIterable, CountryCSVData {
    case id = "country_id"
    case googleMapsUrl = "google_maps_url"
    case openStreetMapsUrl = "openstreetmaps_url"
    
    private var csvType: CSVType {
        switch self {
        case .id: .integer
        case .googleMapsUrl: .string
        case .openStreetMapsUrl: .string
        }
    }
    
    static var csvTypes: [String: CSVType] {
        Self.allCases.reduce(into: [String: CSVType]()) { partialResult, key in
            partialResult[key.rawValue] = key.csvType
        }
    }
}

enum CountryCurrencyRows {
    
}

enum CountryContinentRows {}

enum CountryCapitalKrRows {}

enum CountryCapitalInfoRows {}

enum CountryBorderRows {}


