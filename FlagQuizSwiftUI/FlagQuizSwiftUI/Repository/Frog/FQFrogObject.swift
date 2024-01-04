//
//  FQFrogObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import Foundation
import FirebaseFirestore

struct FQFrogObject: Codable {
    @DocumentID var id: String?
    var status: Int
    var lastUpdated: Timestamp
    var item: [FQItemObject]
}

extension FQFrogObject {
    func toModel() -> FQFrog? {
        guard let id else { return nil }
        return .init(
            userId: id,
            status: .safeValue(rawValue: status),
            lastUpdated: lastUpdated.dateValue(),
            item: item.compactMap { $0.toModel() }
        )
    }
}
