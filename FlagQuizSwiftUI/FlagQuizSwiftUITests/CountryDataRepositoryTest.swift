//
//  CountryDataRepositoryTest.swift
//  FlagQuizSwiftUITests
//
//  Created by Martin on 1/4/26.
//

import Testing
@testable import FlagQuizSwiftUI

struct CountryDataRepositoryTest {
    let repository: CountryDataRepository = CountryDataRepositoryImpl()

    @Test func csvHeader가제대로출력이되는지() async throws {
        let result = try repository.getDataFromCSV()
        #expect(result == ["id",
                           "cca3",
                           "name_common",
                           "name_official",
                           "region",
                           "lat",
                           "lng",
                           "area",
                           "population"])
    }

}
