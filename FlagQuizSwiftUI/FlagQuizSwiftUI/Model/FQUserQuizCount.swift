//
//  FQUserQuizCount.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUserQuizCount: Codable {
    @DocumentID var userId: String?
    var correctCountryQuizCount: Int
    var countryQuizCount: Int
    
    var correctCaptialQuizCount: Int
    var captialQuizCount: Int
}
