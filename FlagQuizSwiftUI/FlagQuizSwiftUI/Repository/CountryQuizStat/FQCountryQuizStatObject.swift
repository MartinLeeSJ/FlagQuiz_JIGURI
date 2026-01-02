//
//  FQCountryQuizStatObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation
import FirebaseFirestore

struct FQCountryQuizStatObject: Codable {
    @DocumentID var id: String?
    var quizStat: Int?
    var capitalQuizStat: Int?
}

extension FQCountryQuizStatObject {
    func toModel() -> FQCountryQuizStat? {
        guard let id else { return nil }
        guard let countryISOCode = FQCountryISOCode(numeric: id) else { return nil }
        return .init(
            id: countryISOCode,
            quizStat: quizStat,
            capitalQuizStat: capitalQuizStat
        )
    }
}
