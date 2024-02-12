//
//  FrogPhotoBoothView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/5/24.
//

import SwiftUI

struct FrogPhotoBoothView: View {
    @Environment(\.displayScale) var displayScale
    @State private var didTapTakeAPhoto: Bool = false
    @State private var flashOpacity: CGFloat = 1
    @State private var renderedImage: Image?
    @StateObject private var viewModel: FrogPhotoBoothViewModel
    
    private let frog: FQFrog
    
    
    init(frog: FQFrog, viewModel: FrogPhotoBoothViewModel) {
        self.frog = frog
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        VStack {
            Spacer()
            
            if viewModel.items.count == viewModel.loadedImageCount {
                cameraTargetView
            } else {
                placeHolderView
            }
            
            Spacer()
            
            takeAPhotoButton
            
            
            Group {
                if let renderedImage {
                   shareButton(renderedImage)
                } else {
                   preparingText
                }
            }
            .padding(.bottom)
            .opacity(didTapTakeAPhoto ? 1 : 0)
            .animation(.easeInOut, value: didTapTakeAPhoto)
            
            Spacer()
  
        }
        .frame(maxWidth: .infinity)
        .background(.black, ignoresSafeAreaEdges: .all)
        .onChange(of: viewModel.didFinishLoading) { finished in
            if finished {
                render()
            }
        }
        .overlay {
            if didTapTakeAPhoto {
               flash
            }
        }
        .task {
            await viewModel.loadImage()
        }
        
    }
    
    var frogImageView: some View {
        ZStack {
            itemImage(ofType: .background)
            
            Image(frog.state.frogImageName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200)
            
            itemImage(ofType: .shoes)
            
            itemImage(ofType: .bottom)
            
            itemImage(ofType: .gloves)
            
            itemImage(ofType: .top)
            
            itemImage(ofType: .overall)
            
            itemImage(ofType: .faceDeco)
            
            itemImage(ofType: .accessory)
            
            itemImage(ofType: .hair)
            
            itemImage(ofType: .hat)
            
            itemImage(ofType: .set)
        }
    }
    
    private var cameraTargetView: some View {
        frogImageView
            .clipShape(.rect(cornerRadius: 10, style: .continuous))
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.white)
            }
            .overlay {
                Image("cameraTarget")
                    .resizable()
                    .scaledToFit()
                    .opacity(0.5)
            }
    }
    
    private var placeHolderView: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .frame(width: 200, height: 200)
            .foregroundStyle(.white)
            .shadow(radius: 10)
            .overlay {
                ProgressView()
            }
    }
    
    private var takeAPhotoButton: some View {
        Button {
            didTapTakeAPhoto = true
            UIImpactFeedbackGenerator(style: .heavy)
                 .impactOccurred()
        } label: {
            Text(
                String(
                    localized:"frogPhotoBoothView.takeAPhotoButton.title",
                    defaultValue: "Take a photo"
                )
            )
            .font(.headline)
            .foregroundStyle(.white)
        }
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .tint(.red)
        .disabled(didTapTakeAPhoto)
        .shadow(color: .red, radius: didTapTakeAPhoto ? 0 : 10)
    }
    
    private func shareButton(_ renderedImage: Image) -> some View {
        ShareLink(item: renderedImage, preview: .init("Image", image: renderedImage)) {
            Text(
                String(
                    localized:"frogPhotoBoothView.share.title",
                    defaultValue: "Click here and share this photo"
                )
            )
        }
        .buttonStyle(
            FQFilledButtonStyle(
                disabled: false,
                colorSchemeMode: .darkOnly
            )
        )
        .padding()
    }
    
    private var preparingText: some View {
        Text(
            String(
                localized:"frogPhotoBoothView.preparing.title",
                defaultValue: "Wait a second..."
            )
        )
        .foregroundStyle(.fqAccent)
        .padding()
    }
    
    private var flash: some View {
        Rectangle()
            .foregroundStyle(.white)
            .ignoresSafeArea(.all)
            .opacity(flashOpacity)
            .onAppear {
                withAnimation(.easeInOut) {
                    flashOpacity = 0
                }
            }
    }
    
    @ViewBuilder
    func itemImage(ofType type: FQItemType) -> some View {
        if let imageOfItemType = viewModel.imagesOfItemType[type],
           let image = imageOfItemType {
            image
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200)
        }
    }
    
    var stickerPhotoView: some View {
        VStack {
            frogImageView
                .background(.white)
                .clipShape(.rect(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 80)
                .background(in: .rect)
                .backgroundStyle(.fqAccentPastel)
                .overlay {
                    Rectangle()
                        .stroke(.black, lineWidth: 1)
                }
                .overlay(alignment: .bottomTrailing) {
                    HStack(spacing: 1) {
                        Image("frogHeadBig")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24)
                        Text(
                            String(
                                localized: "frogPhotoBoothView.rederedView.app.title",
                                defaultValue: "FlagFrog"
                            )
                        )
                        .font(.custom(FontName.pixel, size: 14))
                    }
                    .padding()
                }
                .padding(64)
        }
        .background(.white)
    }
  
 
    @MainActor
    func render() {
        let renderer = ImageRenderer(content: stickerPhotoView)
        
        renderer.isOpaque = true
        renderer.scale = displayScale
        
        if let uiImage = renderer.uiImage {
          renderedImage = Image(uiImage: uiImage)
        }
    }
}




#Preview {
    FrogPhotoBoothView(
        frog: .init(
            userId: "1",
            state: .great,
            lastUpdated: .now,
            items: []
        ),
        viewModel: .init(
            container: .init(services: StubService()),
            items: []
        )
    )
//    .stickerPhotoView
    
}
