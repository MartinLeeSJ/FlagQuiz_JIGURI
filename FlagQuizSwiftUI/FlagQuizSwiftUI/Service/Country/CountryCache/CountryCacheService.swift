//
//  CountryCacheService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/25/23.
//

import Foundation
import Combine

protocol CountryCacheServiceType {
    func countryObjects(for codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], Never>
    func store(countryObjects: [CountryObject], alsoInDisk shouldStoreInDisk: Bool)
}

final class CountryCacheService: CountryCacheServiceType {
    private let countryMemoryStorage: CountryMemoryStorageType
    private let countryDiskStorage: CountryDiskStorageType
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        countryMemoryStorage: CountryMemoryStorageType,
        countryDiskStorage: CountryDiskStorageType
    ) {
        self.countryMemoryStorage = countryMemoryStorage
        self.countryDiskStorage = countryDiskStorage
    }
    
    func countryObjects(for codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], Never> {
        countryObjectsInMemoryCache(for: codes)
            .flatMap { [weak self] objects -> AnyPublisher<[CountryObject]?, Never> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                if let objects {
                    return Just(objects).eraseToAnyPublisher()
                }
                
                return self.countryObjectsInDiskCache(for: codes)
            }
            .replaceNil(with: [])
            .eraseToAnyPublisher()
    }
    
    private func countryObjectsInMemoryCache(
        for codes: [FQCountryISOCode]
    ) -> AnyPublisher<[CountryObject]?, Never> {
        Future { [weak self] promise in
            let objects: [CountryObject]? = self?.countryMemoryStorage.countryObjects(for: codes.map { $0.numericCode })
            promise(.success(objects))
        }
        .eraseToAnyPublisher()
    }
    
    private func countryObjectsInDiskCache(
        for codes: [FQCountryISOCode]
    ) -> AnyPublisher<[CountryObject]?, Never>  {
        Future { [weak self] promise in
            do {
                let objects: [CountryObject]? = try self?.countryDiskStorage.countryObjects(for: codes.map { $0.numericCode })
                promise(.success(objects))
            } catch {
                promise(.success(nil))
            }
        }
        .handleEvents(receiveOutput: { [weak self] objects in
            if let objects {
                self?.store(countryObjects: objects, alsoInDisk: false)
            }
        })
        .eraseToAnyPublisher()
    }
    
    func store(countryObjects: [CountryObject], alsoInDisk shouldStoreInDisk: Bool) {
        countryMemoryStorage.store(countryObjects)
        
        if shouldStoreInDisk {
            try? countryDiskStorage.store(countryObjects)
        }
    }

}

final class StubCountryCacheService: CountryCacheServiceType {

    func countryObjects(for codes: [FQCountryISOCode]) -> AnyPublisher<[CountryObject], Never> {
        Empty().eraseToAnyPublisher()
    }
    
    func store(countryObjects: [CountryObject], alsoInDisk shouldStoreInDisk: Bool) {
        
    }
}
