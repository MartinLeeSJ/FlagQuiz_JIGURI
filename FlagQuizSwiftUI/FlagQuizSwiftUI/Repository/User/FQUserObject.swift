//
//  FQUserObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUserObject: Codable {
    @DocumentID var id: String?
    var createdAt: Timestamp
    var email: String?
    var userName: String?
    var isAnonymous: Bool?
}

extension FQUserObject {
    func toModel() -> FQUser? {
        guard let id else { return nil }
        
        return .init(
            id: id,
            createdAt: createdAt.dateValue(),
            email: email,
            userName: userName,
            isAnonymous: isAnonymous
        )
    }
    
    func toModel(withId userId: String) -> FQUser {
        .init(
            id: userId,
            createdAt: createdAt.dateValue(),
            email: email,
            userName: userName,
            isAnonymous: isAnonymous
        )
    }
}
