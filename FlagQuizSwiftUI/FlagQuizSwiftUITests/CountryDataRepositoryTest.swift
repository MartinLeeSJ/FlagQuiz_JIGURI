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

    @Test func csvLoad가잘되는지() async throws {
        let countries = try await repository.loadCountries()
//        4,TUN,Tunisia,Tunisian Republic,Africa,34,9,163610,11818618
        #expect(countries[4]?.cca3 == "TUN")
    }

}
