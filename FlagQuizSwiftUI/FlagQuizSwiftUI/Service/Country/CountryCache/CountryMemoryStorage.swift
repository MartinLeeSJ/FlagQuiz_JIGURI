//
//  CountryMemoryStorage.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/25/23.
//

import Foundation

protocol CountryMemoryStorageType {
    func countryObjects(for keys: [String]) -> [CountryObject]
    func store(_ countryObjects: [CountryObject])
    
    
}

final class CountryMemoryStorage: CountryMemoryStorageType {
    
    private var cache = NSCache<NSString, StructWrapper<CountryObject>>()
    
    
    public func countryObjects(for keys: [String]) -> [CountryObject] {
        keys.compactMap {
            cache.object(forKey: $0 as NSString)?.value
        }
    }
    
    public func store(_ countryObjects: [CountryObject]) {
        countryObjects.forEach {
            cache.setObject(.init($0), forKey: NSString(string: $0.ccn3))
        }
    }
}
