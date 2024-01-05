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
        apiClient.getCountries(of: codes)
            .map{
                $0.map { object in
                    object.toCountryModel()
                }
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
           
    }
    
    public func getCountryDetails(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountryDetail], ServiceError> {
        apiClient.getCountries(of: codes)
            .map{
                $0.map { object in
                    object.toCountryDetailModel()
                }
            }
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
}

final class StubCountryService: CountryServiceType {
    public func getCountries(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountry], ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
    public func getCountryDetails(ofCodes codes:[FQCountryISOCode]) -> AnyPublisher<[FQCountryDetail], ServiceError> {
        Just([FQCountryDetail.mock]).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
    }
}
