//
//  FQQuizRecordObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import Foundation
import FirebaseFirestore

struct FQQuizRecordObject {
    @DocumentID var id: String?
    let quizCount: Int
    let quizOptionsCount: Int
    let quizRounds: [FQQuizRoundRecordObject]
    let createdAt: Timestamp
}
