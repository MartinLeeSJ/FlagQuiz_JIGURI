//
//  CountryData+AllIDs.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/27/26.
//

import Foundation

extension CountryData {
    public static func getRandomCountryDataIDs(ofCount count: Int) -> [Int] {
        let idRange = 4..<254
        guard count < 30 else { return [] }
        var result: Set<Int> = []
        while result.count < count {
            result.insert(Int.random(in: idRange))
        }
        return Array<Int>(result)
    }
}
