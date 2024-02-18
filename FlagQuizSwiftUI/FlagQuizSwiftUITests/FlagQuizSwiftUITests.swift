//
//  FlagQuizSwiftUITests.swift
//  FlagQuizSwiftUITests
//
//  Created by Martin on 12/12/23.
//

import XCTest
import Combine
@testable import FlagQuizSwiftUI


class MockCountryService: CountryServiceType {
    private let apiClient: CountryAPIClientType
    
    init(apiClient: CountryAPIClientType) {
        self.apiClient = apiClient
    }
    
    func getCountries(ofCodes codes: [FlagQuizSwiftUI.FQCountryISOCode]) -> AnyPublisher<[FlagQuizSwiftUI.FQCountry], FlagQuizSwiftUI.ServiceError> {
        apiClient.getCountries(of: .init(codes))
            .encode(encoder: JSONEncoder())
            .decode(type: [FQCountry].self, decoder: JSONDecoder())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
    
    func getCountryDetails(ofCodes codes: [FlagQuizSwiftUI.FQCountryISOCode]) -> AnyPublisher<[FlagQuizSwiftUI.FQCountryDetail], FlagQuizSwiftUI.ServiceError> {
        apiClient.getCountries(of: .init(codes))
            .encode(encoder: JSONEncoder())
            .decode(type: [FQCountryDetail].self, decoder: JSONDecoder())
            .mapError { ServiceError.custom($0) }
            .eraseToAnyPublisher()
    }
}

final class MockCountryAPIClient: CountryAPIClientType {
    func getCountries(of codes: [FlagQuizSwiftUI.FQCountryISOCode]) -> AnyPublisher<[FlagQuizSwiftUI.CountryObject], FlagQuizSwiftUI.APIError> {
        Empty().eraseToAnyPublisher()
    }
    
    func getCountries(_ request: FlagQuizSwiftUI.CountryRequest) -> AnyPublisher<[FlagQuizSwiftUI.CountryObject], FlagQuizSwiftUI.APIError> {
        Future { promise in
            do {
                let objects = try JSONDecoder().decode([CountryObject].self, from: testCountryJSON170)
                promise(.success(objects))
            } catch {
                promise(.failure(APIError.custom(error)))
            }
        }
        .eraseToAnyPublisher()
    }
}

struct MockCountryRequest: CountryRequestType {
    let countryCodes: [FlagQuizSwiftUI.FQCountryISOCode]
    
    init(countryCodes: [FlagQuizSwiftUI.FQCountryISOCode]) {
        self.countryCodes = countryCodes
    }
}

final class FlagQuizSwiftUITests: XCTestCase {
    var countryService: CountryServiceType?
    var countryAPIClient: CountryAPIClientType?
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        let mockClient = MockCountryAPIClient()
        countryAPIClient = mockClient
        countryService = MockCountryService(apiClient: mockClient)
    }
    
    override func tearDownWithError() throws {
        countryAPIClient = nil
        countryService = nil
    }
    

    func testDecodeCountryObject() {
        
        countryAPIClient?.getCountries(of: .init([.init("170")]))
            .sink{ completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { objects in
                guard let object = objects.first else {
                    XCTFail("")
                    return
                }
                
                XCTAssertEqual(object.ccn3, "170")
                XCTAssertEqual(object.subregion, "South America")
            
            }
            .store(in: &subscriptions)
    }
    
    
    func testDecodeFQCountry() {
        
        countryService?.getCountries(ofCodes: [.init("170")])
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { countries in
                guard let country = countries.first else {
                    XCTFail("")
                    return
                }
                
                XCTAssertEqual(country.id, .init("170"))
                
            }
            .store(in: &subscriptions)
    }
    
    func testDecodeFQCountryDetail() {
        countryService?.getCountryDetails(ofCodes: [.init("170")])
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { countries in
                guard let country = countries.first else {
                    XCTFail("")
                    return
                }
                
                XCTAssertEqual(country.id, .init("170"))
                XCTAssertEqual(country.region, .americas)
                XCTAssertEqual(country.subregion, .southAmerica)
            }
            .store(in: &subscriptions)
    }
    
    
    

}
