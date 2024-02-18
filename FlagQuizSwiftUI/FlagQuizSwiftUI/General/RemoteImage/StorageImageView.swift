//
//  StorageImageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import SwiftUI
import FirebaseStorage

struct StorageImageView<Placeholder>: View where Placeholder: View {
    @EnvironmentObject private var container: DIContainer
    
    private let storageReferencePath: String?
    private let placeholder: () -> Placeholder
    private let completion: () -> Void
    
    
    init(
        _ storageReferencePath: String?,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        completion: @escaping () -> Void = {}
    ) {
        self.storageReferencePath = storageReferencePath
        self.placeholder = placeholder
        self.completion = completion
    }
    
    var body: some View {
        if let storageReferencePath {
            StorageImageInnerView(
                viewModel: .init(
                    container: container,
                    storagePath: storageReferencePath
                ),
                placeholder: placeholder,
                completion: completion
            )
            .id(storageReferencePath)
        } else {
            placeholder()
        }
    }
}

fileprivate struct StorageImageInnerView<Placeholder>: View where Placeholder: View {
    @StateObject private var viewModel: StorageImageViewModel
    private let placeholder: () -> Placeholder
    private let completion: () -> Void
    
    init(
        viewModel: StorageImageViewModel,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        completion: @escaping () -> Void = {}
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.placeholder = placeholder
        self.completion = completion
    }
    
    var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                placeholder()
            }
        }
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.loadImage()
            }
        }
        .onChange(of: viewModel.loadingState) { state in
            if state == .loaded {
                completion()
            }
        }
    }
    
}
