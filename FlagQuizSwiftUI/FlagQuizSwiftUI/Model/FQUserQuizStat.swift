//
//  FQUserQuizStat.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUserQuizStat: Codable {
    @DocumentID var userId: String?
    var correctCountryQuizCount: Int
    var countryQuizCount: Int
    
    var correctCaptialQuizCount: Int
    var captialQuizCount: Int
}
