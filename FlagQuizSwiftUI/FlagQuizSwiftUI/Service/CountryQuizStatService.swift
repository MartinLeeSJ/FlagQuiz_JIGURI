//
//  CountryQuizStatService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import Foundation

protocol CountryQuizStatServiceType {
    func getCountryQuizStats(
        of userId: String
    ) async throws -> [FQCountryQuizStat]
    
    func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [FQCountryISOCode],
        substractingCodes substracting: [FQCountryISOCode]
    ) async throws
}

final class CountryQuizStatService: CountryQuizStatServiceType {
    
    private let repository: FQCountryQuizStatRepositoryType
    
    init(repository: FQCountryQuizStatRepositoryType) {
        self.repository = repository
    }
    
    func getCountryQuizStats(
        of userId: String
    ) async throws -> [FQCountryQuizStat] {
        let objects: [FQCountryQuizStatObject] = try await repository.getCountryQuizStats(of: userId)
        
        return objects.compactMap { $0.toModel() }
    }
    
    func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [FQCountryISOCode],
        substractingCodes substracting: [FQCountryISOCode]
    ) async throws {
        try await repository.updateCountryQuizStats(
            userId: userId,
            addingCodes: adding.map { $0.numericCode },
            substractingCodes: substracting.map { $0.numericCode }
        )
    }
}

final class StubCountryQuizStatService: CountryQuizStatServiceType {
    
    func getCountryQuizStats(
        of userId: String
    ) async throws -> [FQCountryQuizStat] {
        []
    }
    
    func updateCountryQuizStats(
        userId: String,
        addingCodes adding: [FQCountryISOCode],
        substractingCodes substracting: [FQCountryISOCode]
    ) async throws {
        
    }
}
