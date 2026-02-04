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
    
//    25,UTC+03:00
//    25,UTC+04:00
//    25,UTC+06:00
//    25,UTC+07:00
//    25,UTC+08:00
//    25,UTC+09:00
//    25,UTC+10:00
//    25,UTC+11:00
//    25,UTC+12:00
    @Test func timezonesLoad가잘되는지() async throws {
        let countries = try await repository.loadCountries()
        #expect(countries[25]?.timezone.count == 9)
    }

}
