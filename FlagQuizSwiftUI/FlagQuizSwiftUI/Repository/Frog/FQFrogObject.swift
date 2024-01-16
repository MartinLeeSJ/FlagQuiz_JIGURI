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
    var items: [String]
    var nationNumericCode: String?
}

extension FQFrogObject {
    func toModel() -> FQFrog? {
        guard let id else { return nil }
        return .init(
            userId: id,
            state: .safeValue(rawValue: status),
            lastUpdated: lastUpdated.dateValue(),
            items: items,
            nation: .init(nationNumericCode)
        )
    }
}
