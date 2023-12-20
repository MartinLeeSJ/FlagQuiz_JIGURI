//
//  CountryAPIClient.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation
import Combine

protocol CountryAPIClientType {
    func getCountries(_ request: CountryRequest) -> AnyPublisher<[CountryObject], APIError>
}

class CountryAPIClient: CountryAPIClientType {
    
    func getCountries(_ request: CountryRequest) -> AnyPublisher<[CountryObject], APIError> {
        guard let url = request.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { (data, _) in
                let decoder = JSONDecoder()
                return try? decoder.decode([CountryObject].self, from: data)
            }
            .mapError { APIError.custom($0) }
            .eraseToAnyPublisher()
    }
}
