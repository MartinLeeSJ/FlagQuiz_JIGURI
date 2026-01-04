//
//  CountryDataRepository.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/2/26.
//

import Foundation
import SwiftCSV

public protocol CountryDataRepository {
    func getDataFromCSV() throws -> [String]
}

public actor CountryDataRepositoryImpl: CountryDataRepository {
    nonisolated public func getDataFromCSV() throws -> [String] {
//        id,cca3,name_common,name_official,region,lat,lng,area,population
        let filePath = Bundle.main.path(forResource: "country_rows", ofType: "csv")
        let csv: CSV = try CSV<Named>(url: URL(filePath: filePath ?? ""))
        return csv.header
    
    }
}

public struct CountryData {
    
}
