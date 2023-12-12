//
//  FQUserObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUserObject: Codable {
    var id: String
    var createdAt: Timestamp
    var email: String?
    var userName: String?
}

extension FQUserObject {
    func toModel() -> FQUser {
        .init(
            id: id,
            createdAt: createdAt.dateValue(),
            email: email,
            userName: userName
        )
    }
}
