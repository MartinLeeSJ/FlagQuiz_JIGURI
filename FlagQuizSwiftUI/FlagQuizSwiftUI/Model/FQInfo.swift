//
//  FQInfo.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/13/24.
//

import Foundation
import FirebaseFirestore

struct FQInfo: Codable, Hashable {
    @DocumentID var id: String?
    let title: String
    let subtitle: String
    let body: String
    let pinned: Bool
    let languageAlpha2Code: String
    private let timestamp: Timestamp
    
    var createdAt: Date {
        timestamp.dateValue()
    }
    
    init(id: String? = nil, title: String, subtitle: String, body: String, pinned: Bool, languageAlpha2Code: String, timestamp: Timestamp) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.pinned = pinned
        self.languageAlpha2Code = languageAlpha2Code
        self.timestamp = timestamp
    }
}

