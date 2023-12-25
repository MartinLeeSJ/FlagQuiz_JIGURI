//
//  CountryAPIClient.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import Combine

protocol CountryAPIClientType {
    func getCountries(of codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], APIError>
}

class CountryAPIClient: CountryAPIClientType {
    private let cacheService: CountryCacheServiceType
    
    init(cacheService: CountryCacheServiceType) {
        self.cacheService = cacheService
    }
    
    
    func getCountries(of codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], APIError> {
        cacheService.countryObjects(for: codes)
            .flatMap { [weak self] cachedObjects -> AnyPublisher<[CountryObject], APIError> in
                guard let self else {
                    return Fail<[CountryObject], APIError>(error: .invalidated).eraseToAnyPublisher()
                }
                
                let codesShouldFetch: [FQCountryISOCode] = codes.filter { code in
                    !cachedObjects.contains { $0.ccn3 == code.numericCode }
                }
                
                
                return self.getRemoteCountrise(of: codesShouldFetch)
                    .map { $0 + cachedObjects }
                    .map { test in
                        test
                    }
                    .eraseToAnyPublisher()
                    
            }
            .eraseToAnyPublisher()
 
    }
    
    func getRemoteCountrise(of codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], APIError> {
        guard !codes.isEmpty else {
            return Empty().eraseToAnyPublisher()
        }
        
        let newRequest: CountryRequest = CountryRequest(countryCodes: codes)
        
        guard let url = newRequest.url else {
            return Fail<[CountryObject], APIError>(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.httpStatusError(statusCode: httpResponse.statusCode, description: response.description)
                }
                
                guard !data.isEmpty else {
                    throw APIError.emptyData
                }
                
                return data
            }
            .decode(type: [CountryObject].self, decoder: JSONDecoder())
            .mapError { APIError.custom($0) }
            .handleEvents(receiveOutput: { [weak self] countryObjects in
                self?.cacheService.store(countryObjects: countryObjects, alsoInDisk: true)
            })
           .eraseToAnyPublisher()
    }
}
