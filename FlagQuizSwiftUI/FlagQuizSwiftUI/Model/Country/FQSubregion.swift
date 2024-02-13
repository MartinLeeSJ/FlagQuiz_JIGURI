//
//  FQSubregion.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/13/24.
//

import Foundation

enum FQSubregion: String, Codable {
    case northernAfrica = "Northern Africa"
    case easternAfrica = "Eastern Africa"
    case middelAfrica = "Middle Africa"
    case southernAfrica = "Southern Africa"
    case westernAfrica = "Western Africa"
    case caribbean = "Caribbean"
    case centralAmerica = "Central America"
    case southAmerica = "South America"
    case northAmerica = "North America"
    case centralAsia = "Central Asia"
    case easternAsia = "Eastern Asia"
    case southEasternAsia = "South-Eastern Asia"
    case southernAsia = "Southern Asia"
    case westernAsia = "Western Asia"
    case centralEurope = "Central Europe"
    case easternEurope = "Eastern Europe"
    case northernEurope = "Northern Europe"
    case southernEurope = "Southern Europe"
    case southEasternEurope = "Southeast Europe"
    case westernEurope = "Western Europe"
    case australiaAndNewZealand = "Australia and New Zealand"
    case melanesia = "Melanesia"
    case micronesia = "Micronesia"
    case polynesia = "Polynesia"
    
    var localizedName: String {
        switch self {
        case .northernAfrica:
            String(
                localized: "fqSubregion.northernAfrica",
                defaultValue: "Northern Africa"
            )
        case .easternAfrica:
            String(
                localized: "fqSubregion.easternAfrica",
                defaultValue: "Eastern Africa"
            )
        case .middelAfrica:
            String(
                localized: "fqSubregion.middelAfrica",
                defaultValue: "Middle Africa"
            )
        case .southernAfrica:
            String(
                localized: "fqSubregion.southernAfrica",
                defaultValue: "Southern Africa"
            )
        case .westernAfrica:
            String(
                localized: "fqSubregion.westernAfrica",
                defaultValue: "Western Africa"
            )
        case .caribbean:
            String(
                localized: "fqSubregion.caribbean",
                defaultValue: "Caribbean"
            )
        case .centralAmerica:
            String(
                localized: "fqSubregion.centralAmerica",
                defaultValue: "Central America"
            )
        case .southAmerica:
            String(
                localized: "fqSubregion.southAmerica",
                defaultValue: "South America"
            )
        case .northAmerica:
            String(
                localized: "fqSubregion.northAmerica",
                defaultValue: "North America"
            )
        case .centralAsia:
            String(
                localized: "fqSubregion.centralAsia",
                defaultValue: "Central Asia"
            )
        case .easternAsia:
            String(
                localized: "fqSubregion.easternAsia",
                defaultValue: "Eastern Asia"
            )
        case .southEasternAsia:
            String(
                localized: "fqSubregion.southEasternAsia",
                defaultValue: "South-Eastern Asia"
            )
        case .southernAsia:
            String(
                localized: "fqSubregion.southernAsia",
                defaultValue: "Southern Asia"
            )
        case .westernAsia:
            String(
                localized: "fqSubregion.westernAsia",
                defaultValue: "Western Asia"
            )
        case .centralEurope:
            String(
                localized: "fqSubregion.centralEurope",
                defaultValue: "Central Europe"
            )
        case .southEasternEurope:
            String(
                localized: "fqSubregion.southEasternEurope",
                defaultValue: "Southeast Europe"
            )
        case .easternEurope:
            String(
                localized: "fqSubregion.easternEurope",
                defaultValue: "Eastern Europe"
            )
        case .northernEurope:
            String(
                localized: "fqSubregion.northernEurope",
                defaultValue: "Northern Europe"
            )
        case .southernEurope:
            String(
                localized: "fqSubregion.southernEurope",
                defaultValue: "Southern Europe"
            )
        case .westernEurope:
            String(
                localized: "fqSubregion.westernEurope",
                defaultValue: "Western Europe"
            )
        case .australiaAndNewZealand:
            String(
                localized: "fqSubregion.australiaAndNewZealand",
                defaultValue: "Australia and New Zealand"
            )
        case .melanesia:
            String(
                localized: "fqSubregion.melanesia",
                defaultValue: "Melanesia"
            )
        case .micronesia:
            String(
                localized: "fqSubregion.micronesia",
                defaultValue: "Micronesia"
            )
        case .polynesia:
            String(
                localized: "fqSubregion.polynesia",
                defaultValue: "Polynesia"
            )
        }
    }
}
