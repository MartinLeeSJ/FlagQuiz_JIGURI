//
//  CountryDetailInfo.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import SwiftUI

enum CountryDetailInfo: String, CaseIterable {
    case capitals
    case coordinates
    case languages
    case area
    case population
    case borderedCountries
    case timezones
    case continents
    
    
// MARK: - 보라색 에러가 왜 발생하는지 연구해보기
    var localizedTitleKey: LocalizedStringKey {
        switch self {
        case .capitals:
            "county.detail.title.capitals"
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
        case .capitals:
           return detail.capitals?.joined(separator: ", ") ?? "-"
        case .coordinates:
            return detail.coordinates.compactMap { $0.description }.joined(separator: ", ")
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
