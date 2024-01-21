//
//  ImageMemoryStorage.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import UIKit

protocol ImageMemoryStorageType {
    func image(for key: String) -> UIImage?
    func store(for key: String, image: UIImage)
}

final class ImageMemoryStorage: ImageMemoryStorageType {
    
    private var cache = NSCache<NSString, UIImage>()
    
    func image(for key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func store(for key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
