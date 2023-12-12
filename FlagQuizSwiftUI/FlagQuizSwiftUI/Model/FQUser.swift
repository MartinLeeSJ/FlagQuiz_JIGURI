//
//  FQUser.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation
import FirebaseFirestore

struct FQUser: Codable {
    @DocumentID var id: String?
    var createdAt: Timestamp
    var email: String?
    var userName: String?
    
}

