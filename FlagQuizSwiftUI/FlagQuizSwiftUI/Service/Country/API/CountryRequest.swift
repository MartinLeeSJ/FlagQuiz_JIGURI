//
//  CountryRequest.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

protocol CountryRequestType {
    var countryCodes: [FQCountryISOCode] { get }
}

struct CountryRequest: CountryRequestType {
    private struct Constants {
        static let scheme = "https"
        static let host = "restcountries.com"
        static let path = "/v3.1/alpha"
    }
    
    let countryCodes: [FQCountryISOCode]
    
    init(countryCodes: [FQCountryISOCode]) {
        self.countryCodes = countryCodes
    }
    
    public var url: URL? {
        var components = URLComponents()
        components.scheme = Constants.scheme
        components.host = Constants.host
        components.path = Constants.path
        
        let queryString: String = countryCodes
            .compactMap { $0.numericCode }
            .joined(separator: ",")
        
        components.queryItems = [
            URLQueryItem(name: "codes", value: queryString)
        ]
        
        return components.url
    }
}
