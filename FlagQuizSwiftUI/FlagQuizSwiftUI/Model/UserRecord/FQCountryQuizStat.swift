//
//  FQCountryQuizStat.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation


struct FQCountryQuizStat: Identifiable, Hashable {
    let id: FQCountryISOCode
    var quizStat: Int?
    var capitalQuizStat: Int?
}
