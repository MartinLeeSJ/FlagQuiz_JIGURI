//
//  CountryDiskStorage.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/25/23.
//

import Foundation

protocol CountryDiskStorageType {
    func countryObjects(for keys: [String]) throws -> [CountryObject]?
    func store(_ countryObjects: [CountryObject]) throws
}

final class CountryDiskStorage: CountryDiskStorageType {

    private let fileManager: FileManager
    private let directoryURL: URL
    
    init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathExtension("CountryObjectCache")
    }
    
    private func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    private func createFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    func countryObjects(for keys: [String]) throws -> [CountryObject]? {
        keys.compactMap {
            let fileURL: URL = createFileURL(for: $0)
            
            guard fileManager.fileExists(atPath: fileURL.path()) else {
                return nil
            }
            
            if let data = try? Data(contentsOf: fileURL) {
                return try? JSONDecoder().decode(CountryObject.self, from: data)
            }
            
            return nil
        }
    }
    
    func store(_ countryObjects: [CountryObject]) throws {
        try countryObjects.forEach {
            let fileURL: URL = cacheFileURL(for: $0.ccn3)
            let data: Data = try JSONEncoder().encode($0)
            try data.write(to: fileURL)
        }
    }
}
