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
    @State private var urlString: String?
    
    private let storageReferencePath: String?
    private let placeholder: () -> Placeholder
    private let storageRef = Storage.storage().reference()
    
    init(
        _ storageReferencePath: String?,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.storageReferencePath = storageReferencePath
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let storageReferencePath {
            StorageImageInnerView(
                viewModel: .init(
                    container: container,
                    storagePath: storageReferencePath
                ),
                placeholder: placeholder
            )
        } else {
            placeholder()
        }
    }
}

fileprivate struct StorageImageInnerView<Placeholder>: View where Placeholder: View {
    @StateObject private var viewModel: StorageImageViewModel
    private let placeholder: () -> Placeholder
    
    init(
        viewModel: StorageImageViewModel,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.placeholder = placeholder
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
        .transition(.opacity)
        .animation(.easeIn(duration: 1.0), value: viewModel.image)
        .onAppear {
            if viewModel.loadingState == .none {
                viewModel.loadImage()
            }
        }
    }
    
}
