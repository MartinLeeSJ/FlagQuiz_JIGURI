//
//  FQUser.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUser: Codable {
    var id: String
    var createdAt: Date
    var email: String?
    var userName: String?
    var isAnonymous: Bool?
}

extension FQUser {
    func toObject() -> FQUserObject {
        .init(
            id: nil,
            createdAt: Timestamp(date: createdAt),
            email: email,
            userName: userName,
            isAnonymous: isAnonymous
        )
    }
}

