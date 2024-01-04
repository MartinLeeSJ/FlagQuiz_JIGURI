//
//  NewsDestination.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import Foundation

enum NewsDestination: Hashable {
    case countryQuizStat
    case userRank
    case quizRecord
    case myPage
    case quizRecordDetail(FQQuizRecord)
    case countryDetail(FQCountryISOCode)
}
