//
//  FQEarthCandy.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import Foundation

struct FQEarthCandy: Codable {
    let userId: String
    private(set) var point: Double
    
    mutating func add(_ amount: Double) {
        point += amount
    }
    
    mutating func subtract(_ amount: Double) {
        point -= amount
    }
}

extension FQEarthCandy {
    func toObject() -> FQEarthCandyObject {
        .init(userId: userId, point: point)
    }
}
