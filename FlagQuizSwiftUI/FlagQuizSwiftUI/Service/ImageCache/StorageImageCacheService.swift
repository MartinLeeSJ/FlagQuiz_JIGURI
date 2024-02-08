//
//  StorageImageCacheService.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import SwiftUI
import Combine
import FirebaseStorage


final class StorageImageCacheService: ImageCacheServiceType {
    private let imageMemoryStorage: ImageMemoryStorageType
    private let imageDiskStorage: ImageDiskStorageType
    
    private let storageRef = Storage.storage().reference()
    
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
    
    func image(for path: String) async throws -> UIImage? {
        if let memoryCacheImage = imageMemoryStorage.image(for: path) {
            return memoryCacheImage
        }
        
        if let diskCacheImage = try imageDiskStorage.image(for: path) {
            store(for: path, image: diskCacheImage, alsoInDisk: false)
            return diskCacheImage
        }
        
        let url = try await downloadUrl(for: path)
        let response = try await URLSession.shared.data(from: url)
        
        if let remoteImage = UIImage(data: response.0) {
            store(for: path, image: remoteImage, alsoInDisk: true)
            return remoteImage
        }
        
        return nil
    }
    
    private func imageWithMemoryCache(for path: String) -> AnyPublisher<UIImage?, ServiceError> {
        Future { [weak self] promise in
            let image: UIImage? = self?.imageMemoryStorage.image(for: path)
            promise(.success(image))
        }
        .setFailureType(to: ServiceError.self)
        .eraseToAnyPublisher()
    }
    
    private func imageWithDiskCache(for path: String) -> AnyPublisher<UIImage?, ServiceError> {
        Future<UIImage?, ServiceError> { [weak self] promise in
            do {
                let image: UIImage? = try self?.imageDiskStorage.image(for: path)
                promise(.success(image))
            } catch {
                promise(.failure(.invalid))
            }
        }
        .flatMap { image -> AnyPublisher<UIImage?, ServiceError> in
            if let image {
                return Just(image)
                    .setFailureType(to: ServiceError.self)
                    .handleEvents(receiveOutput: { [weak self] image in
                        if let image {
                            self?.store(for: path, image: image, alsoInDisk: false)
                        }
                    })
                    .eraseToAnyPublisher()
            } else {
                return self.remoteImage(for: path)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func remoteImage(for path: String) -> AnyPublisher<UIImage?, ServiceError> {
        downloadUrl(for: path)
            .flatMap { url in
                guard let url else {
                    return Fail<UIImage?, ServiceError>(error: .invalid).eraseToAnyPublisher()
                }
                
                return URLSession.shared.dataTaskPublisher(for: url)
                    .mapError { ServiceError.custom($0) }
                    .map { data, _ in
                        UIImage(data: data)
                    }
                    .handleEvents(receiveOutput: { [weak self] image in
                        if let image {
                            self?.store(for: path, image: image, alsoInDisk: true)
                        }
                    })
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func downloadUrl(for path: String) -> AnyPublisher<URL?, ServiceError> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(.invalid))
                return
            }
            
            self.storageRef.child(path)
                .downloadURL { url, error in
                    guard error == nil else {
                        promise(.failure(.custom(error!)))
                        return
                    }
                    
                    promise(.success(url))
                }
        }
        .eraseToAnyPublisher()
    }
    
    
    private func downloadUrl(for path: String) async throws -> URL {
        try await storageRef.child(path)
            .downloadURL()
    }
    
    private func store(for path: String, image: UIImage, alsoInDisk shouldStoreInDisk: Bool) {
        imageMemoryStorage.store(for: path, image: image)
        
        if shouldStoreInDisk {
            try? imageDiskStorage.store(for: path, image: image, convertToJpeg: false)
        }
    }
    
}
