//
//  StorageImageViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import SwiftUI
import Combine
import FirebaseStorage

final class StorageImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var loadingState: RemoteImageLoadingState = .none
    
    private let container: DIContainer
    private let storageRef = Storage.storage().reference()
    private let storagePath: String
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        container: DIContainer,
        storagePath: String
    ) {
        self.container = container
        self.storagePath = storagePath
    }
    
    func loadImage() {
        loadingState = .loading
        
        container.services.storageImageCacheService.image(for: storagePath)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.loadingState = .failed
                }
            } receiveValue: { [weak self] image in
                withAnimation(.smooth) {
                    self?.image = image
                    self?.loadingState = .loaded                    
                }
            }
            .store(in: &cancellables)
        
    }
    
    
    
    
}
