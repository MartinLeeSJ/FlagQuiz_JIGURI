//
//  FQQuizRecordObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation
import FirebaseFirestore

struct FQQuizRecordObject: Codable {
    @DocumentID var id: String?
    let quizCount: Int
    let quizOptionsCount: Int
    let quizRounds: [FQQuizRoundRecordObject]
    let createdAt: Timestamp
}


extension FQQuizRecordObject {
    func toModel() -> FQQuizRecord {
        .init(
            quizCount: quizCount,
            quizOptionsCount: quizOptionsCount,
            quizRounds: quizRounds.map { $0.toModel() },
            createdAt: createdAt.dateValue()
        )
    }
}
