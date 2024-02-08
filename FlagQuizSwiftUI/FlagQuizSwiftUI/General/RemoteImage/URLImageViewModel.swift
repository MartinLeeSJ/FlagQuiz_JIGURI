//
//  URLImageViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import SwiftUI
import Combine



final class URLImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var loadingState: RemoteImageLoadingState = .none
    
    private let container: DIContainer
    private let imageUrlString: String
    
    private var cancellables = Set<AnyCancellable>()
    

    init(
        container: DIContainer,
        imageUrlString: String
    ) {
        self.container = container
        self.imageUrlString = imageUrlString
    }
    
    func loadImage() {
        loadingState = .loading
        
        container.services.imageCacheService.image(for: imageUrlString)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.loadingState = .failed
                }
            } receiveValue: { [weak self] image in
                self?.image = image
                self?.loadingState = .loaded
            }
            .store(in: &cancellables)
        
    }
    
}
