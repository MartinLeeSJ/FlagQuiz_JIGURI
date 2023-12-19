//
//  CountryService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import Combine

protocol CountryServiceType {
    func getCountries(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountry], ServiceError>
    func getCountryDetails(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountryDetail], ServiceError>
}

final class CountryService: CountryServiceType {
    private let apiClient: CountryAPIClient
    
    init(apiClient: CountryAPIClient) {
        self.apiClient = apiClient
    }
    
    public func getCountries(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountry], ServiceError> {
        apiClient.getCountries(.init(countryCodes: codes))
            .encode(encoder: JSONEncoder())
            .decode(type: [FQCountry].self, decoder: JSONDecoder())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
           
    }
    
    public func getCountryDetails(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountryDetail], ServiceError> {
        apiClient.getCountries(.init(countryCodes: codes))
            .encode(encoder: JSONEncoder())
            .decode(type: [FQCountryDetail].self, decoder: JSONDecoder())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
}

final class StubCountryService: CountryServiceType {
    public func getCountries(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountry], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    public func getCountryDetails(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountryDetail], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
