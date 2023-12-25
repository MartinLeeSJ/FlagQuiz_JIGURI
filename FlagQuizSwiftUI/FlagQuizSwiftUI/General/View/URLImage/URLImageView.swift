//
//  URLImageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/24/23.
//

import SwiftUI

struct URLImageView<Placeholder>: View where Placeholder: View {
    @EnvironmentObject private var container: DIContainer
    
    private let imageUrlString: String?
    private let placeholder: () -> Placeholder
    
    init(
        _ imageUrlString: String?,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.imageUrlString = imageUrlString
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let imageUrlString {
            URLImageInnerView(
                viewModel: .init(container: container, imageUrlString: imageUrlString),
                placeholder: placeholder
            )
            .id(imageUrlString)
        } else {
            placeholder()
        }
    }
    
    
}

fileprivate struct URLImageInnerView<Placeholder>: View where Placeholder: View{
    @StateObject private var viewModel: URLImageViewModel
    
    private let placeholder: () -> Placeholder
    
    
    
    init(
        viewModel: URLImageViewModel,
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
