//
//  ImageDiskStorage.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import UIKit

protocol ImageDiskStorageType {
    func image(for key: String) throws -> UIImage?
    func store(for key: String, image: UIImage) throws
}

final class ImageDiskStorage: ImageDiskStorageType {
    
    private let fileManager: FileManager
    private let directoryURL: URL

    init(
        fileManager: FileManager = .default
    ) {
        self.fileManager = fileManager
        self.directoryURL = fileManager.urls(
            for: .cachesDirectory,
            in: .userDomainMask
        )[0].appendingPathExtension("ImageCache")
        
        createDirectory()
    }
    
    private func createDirectory() {
        guard !fileManager.fileExists(atPath: directoryURL.path()) else { return }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        } catch {
            print(error)
        }
    }
    
    private func cacheFileURL(for key: String) -> URL {
        let fileName = sha256(key)
        return directoryURL.appendingPathComponent(fileName, isDirectory: false)
    }
    
    func image(for key: String) throws -> UIImage? {
        let fileURL: URL = cacheFileURL(for: key)
        
        guard fileManager.fileExists(atPath: fileURL.path()) else {
            return nil
        }
        
        let data = try Data(contentsOf: fileURL)
        return UIImage(data: data)
    }
    
    func store(for key: String, image: UIImage) throws {
        let fileURL: URL = cacheFileURL(for: key)
        let data: Data? = image.jpegData(compressionQuality: 0.8)
        try data?.write(to: fileURL)
    }
}
