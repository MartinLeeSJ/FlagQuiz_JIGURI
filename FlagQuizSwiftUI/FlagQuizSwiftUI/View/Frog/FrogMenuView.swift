//
//  FrogMenuView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/21/24.
//

import SwiftUI

struct FrogMenuView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var newsViewModel: NewsViewModel
    @EnvironmentObject private var frogModel: FrogModel
    
    @State private var shouldPresentPhotoBooth: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            let buttonWidth = geo.size.width / 3
            HStack {
                Spacer()
                toItemStoreButton
                    .frame(maxWidth: buttonWidth)
                toClosetButton
                    .frame(maxWidth: buttonWidth)
                toPhotoBoothButton
                    .frame(maxWidth: buttonWidth)
                Spacer()
            }
        }
        .frame(maxWidth: 500, minHeight: 60, maxHeight: 80)
     
    }
    
    private var toItemStoreButton: some View {
        VStack {
            Button {
                toItemStoreButtonDidTap()
            } label: {
                Image("StoreIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            
            Text("frogView.store.title")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
    
    private func toItemStoreButtonDidTap() {
        if let isAnonymous = newsViewModel.isAnonymousUser(),
           isAnonymous {
            newsViewModel.setLinkingLocation(.store)
        } else {
            container.navigationModel.navigate(to: FrogDestination.store)
        }
    }
    
    private var toClosetButton: some View {
        VStack {
            Button {
                toClosetButtonDidTap()
            } label: {
                Image("ClosetIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            Text("frogView.closet.title")
                .font(.caption)
                .fontWeight(.medium)
        }
    }
    
    private func toClosetButtonDidTap() {
        if let isAnonymous = newsViewModel.isAnonymousUser(),
           isAnonymous {
            newsViewModel.setLinkingLocation(.closet)
        } else {
            container.navigationModel.navigate(to: FrogDestination.closet)
        }
    }
    
    private var toPhotoBoothButton: some View {
        VStack {
            Button {
                toPhotoBoothButtonDidTap()
            } label: {
                Image("PhotoBooth")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
            }
            Text("frogView.photoBooth.title")
                .font(.caption)
                .fontWeight(.medium)
        }
        .sheet(isPresented: $shouldPresentPhotoBooth) {
            if let frog = frogModel.frog {
                FrogPhotoBoothView(
                    frog: frog,
                    viewModel: .init(container: container, items: frogModel.items)
                )
            }
        }
        
    }
    
    private func toPhotoBoothButtonDidTap() {
        if let isAnonymous = newsViewModel.isAnonymousUser(),
           isAnonymous {
            newsViewModel.setLinkingLocation(.photoBooth)
        } else {
            shouldPresentPhotoBooth = true
        }
    }
    
    
    
}

#Preview {
    let container = DIContainer(services: StubService())
    return FrogMenuView()
        .environmentObject(container)
        .environmentObject(
            NewsViewModel(
                container: container
            )
        )
        .environmentObject(FrogModel(container: container, notificationManager: .init()))
}
