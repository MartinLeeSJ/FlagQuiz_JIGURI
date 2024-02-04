//
//  ImageCacheService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import UIKit
import Combine

protocol ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, ServiceError>
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
    
    func image(for key: String) -> AnyPublisher<UIImage?, ServiceError> {
        imageWithMemoryCache(for: key)
            .flatMap { image -> AnyPublisher<UIImage?, ServiceError> in
                if let image {
                    return Just(image).setFailureType(to: ServiceError.self).eraseToAnyPublisher()
                }
                return self.imageWithDiskCache(for: key)
                
            }
            .eraseToAnyPublisher()
    }
    
    private func imageWithMemoryCache(for key: String) -> AnyPublisher<UIImage?, ServiceError> {
        Future { [weak self] promise in
            let image: UIImage? = self?.imageMemoryStorage.image(for: key)
            promise(.success(image))
        }
        .setFailureType(to: ServiceError.self)
        .eraseToAnyPublisher()
    }
    
    private func imageWithDiskCache(for key: String) -> AnyPublisher<UIImage?, ServiceError> {
        Future<UIImage?, Never> { [weak self] promise in
            do {
                let image: UIImage? = try self?.imageDiskStorage.image(for: key)
                promise(.success(image))
            } catch {
                promise(.success(nil))
            }
        }
        .flatMap { image -> AnyPublisher<UIImage?, ServiceError> in
            if let image {
                return Just(image)
                    .setFailureType(to: ServiceError.self)
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
    
    private func remoteImage(for urlString: String) -> AnyPublisher<UIImage?, ServiceError> {
        guard let url =  URL(string: urlString) else {
            return Fail<UIImage?, ServiceError>(error: .invalid).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError{ ServiceError.custom($0) }
            .map { data, _ in
                UIImage(data: data)
            }
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
            try? imageDiskStorage.store(for: key, image: image, convertToJpeg: true)
        }
    }
}

final class StubImageCacheService: ImageCacheServiceType {
    func image(for key: String) -> AnyPublisher<UIImage?, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
    
}

