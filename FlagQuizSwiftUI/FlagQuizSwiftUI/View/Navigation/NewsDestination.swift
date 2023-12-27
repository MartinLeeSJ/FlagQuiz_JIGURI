//
//  NewsDestination.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import Foundation

enum NewsDestination: NavigationDestination {
    case countryQuizStat
    case userRank
    case quizStat
    case countryDetail(FQCountryISOCode)
}
