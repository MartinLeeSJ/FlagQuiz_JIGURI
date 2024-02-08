//
//  FrogPhotoBoothViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/5/24.
//

import SwiftUI


final class FrogPhotoBoothViewModel: ObservableObject {
    @Published var imagesOfItemType: [FQItemType:Image?] = .init()
    @Published var loadedImageCount: Int = 0
    
    public let items: [FQItemProtocol]
    private let container: DIContainer
    
    
    init(container: DIContainer, items: [FQItemProtocol]) {
        self.container = container
        self.items = items
    }
    
    @MainActor
    func loadImage() async {
        let asyncItems = AsyncStream<FQItemProtocol> { [weak self] continuation in
            guard let self else {
                continuation.finish()
                return
            }
            
            for item in items {
                continuation.yield(item)
            }
            
            continuation.finish()
        }
        
        for await item in asyncItems {
            if let uiImage = try? await container.services.storageImageCacheService.image(for: item.storageImagePath(equipped: true)) {
                imagesOfItemType[item.type] = Image(uiImage: uiImage)
                loadedImageCount += 1
            }
        }
    }
}


