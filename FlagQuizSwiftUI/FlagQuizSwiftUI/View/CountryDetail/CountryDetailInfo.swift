//
//  CountryDetailInfo.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import SwiftUI

enum CountryDetailInfo: String, CaseIterable {
    case continents
    case region
    case subregion
    case coordinates
    case capitals
    case languages
    case area
    case population
    case borderedCountries
    case timezones
    
    
    var localizedTitleKey: LocalizedStringKey {
        switch self {
        case .capitals:
            "county.detail.title.capitals"
        case .region:
            "county.detail.title.region"
        case .subregion:
            "county.detail.title.subregion"
        case .coordinates:
            "county.detail.title.coordinates"
        case .languages:
            "county.detail.title.languages"
        case .area:
            "county.detail.title.area"
        case .population:
            "county.detail.title.population"
        case .borderedCountries:
            "county.detail.title.borderedCountries"
        case .timezones:
            "county.detail.title.timezones"
        case .continents:
            "county.detail.title.continents"
        }
    }
    
    private var measurementFormatter: MeasurementFormatter {
        let formatter: MeasurementFormatter = MeasurementFormatter()
        formatter.unitOptions = .naturalScale
        formatter.unitStyle = .short
        return formatter
    }
    
    
    func informativeText(from detail: FQCountryDetail?) -> String {
        guard let detail else { return "" }
    
        switch self {
        case .region:
            return detail.region?.localizedName ?? "-"
        case .subregion:
            return detail.subregion?.localizedName ?? "-"
        case .capitals:
           return detail.capitals?.joined(separator: ", ") ?? "-"
        case .coordinates:
            return detail.coordinates.compactMap { String(format: "%.2f", $0) }.joined(separator: ", ")
        case .languages:
            return detail.languages.joined(separator: ", ")
        case .area:
            return measurementFormatter.string(
                from: .init(
                    value: Double(detail.area * 1_000_000),
                    unit: UnitArea(forLocale: .current)
                )
            )
        case .population:
            return measurementFormatter.string(
                from: .init(
                    value: Double(detail.population),
                    unit: .init(symbol: "")
                )
            )

        case .borderedCountries:
            return detail
                .borderedCountries?
                .compactMap {
                    Locale.current.localizedString(forRegionCode: $0)
                }
                .joined(separator: ", ") ?? "-"
        case .timezones:
            return detail.timezones.joined(separator: ", ")
        case .continents:
            return detail.continents.map { $0.localizedName }.joined(separator: ", ")
        }
        
        
    }
}
