//
//  FQEarthCandyObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation
import FirebaseFirestore


struct FQEarthCandyObject: Codable {
    @DocumentID var userId: String?
    var point: Int
}

extension FQEarthCandyObject {
    func toModel() -> FQEarthCandy? {
        guard let userId else { return nil }
        return .init(userId: userId, point: point)
    }
}
