//
//  ImageCacheService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never>
}

final class ImageCacheService: ImageCacheServiceType {
    private let imageMemoryStorage: ImageMemoryStorageType
    private let imageDiskStorage: ImageDiskStorageType
    
    init(
        imageMemoryStorage: ImageMemoryStorageType,
        imageDiskStorage: ImageDiskStorageType
    ) {
        self.imageMemoryStorage = imageMemoryStorage
        self.imageDiskStorage = imageDiskStorage
    }
    
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        imageWithMemoryCache(for: key)
            .flatMap { image -> AnyPublisher<UIImage?, Never> in
                if let image {
                    return Just(image).eraseToAnyPublisher()
                }
                return self.imageWithDiskCache(for: key)
                
            }
            .eraseToAnyPublisher()
    }
    
    private func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future { [weak self] promise in
            let image: UIImage? = self?.imageMemoryStorage.image(for: key)
            promise(.success(image))
        }
        .eraseToAnyPublisher()
    }
    
    private func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, Never> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image: UIImage? = try self?.imageDiskStorage.image(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        .flatMap { image -> AnyPublisher<UIImage?, Never> in
            if let image {
                return Just(image)
                    .handleEvents(receiveOutput: { [weak self] image in
                        if let image {
                            self?.store(for: key, image: image, alsoInDisk: false)
                        }
                    })
                    .eraseToAnyPublisher()
            } else {
                return self.remoteImage(for: key)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, Never> {
        URLSession.shared.dataTaskPublisher(for: URL(string: urlString)!)
            .map { data, _ in
                UIImage(data: data)
            }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] image in
                if let image {
                    self?.store(for: urlString, image: image, alsoInDisk: true)
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func store(for key: String, image: UIImage, alsoInDisk shouldStoreInDisk: Bool) {
        imageMemoryStorage.store(for: key, image: image)
        
        if shouldStoreInDisk {
            try? imageDiskStorage.store(for: key, image: image)
        }
    }
}

final class StubImageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, Never> {
        Empty().eraseToAnyPublisher()
    }
    
}

