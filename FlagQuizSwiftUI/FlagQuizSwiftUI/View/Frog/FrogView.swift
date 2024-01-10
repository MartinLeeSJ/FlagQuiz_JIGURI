//
//  FrogView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/8/24.
//

import SwiftUI

struct FrogView: View {
    @Environment(\.colorScheme) var scheme
    @EnvironmentObject private var earthCandyViewModel: EarthCandyViewModel
    @StateObject private var viewModel: FrogViewModel
    
    init(viewModel: FrogViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        HStack {
            Spacer()
            if let frog = viewModel.frog {
                content(frog)
            } else {
                placeholder
            }
            Spacer()
        }
        .padding()
        .task {
            viewModel.observe()
        }
        .background {
            if scheme == .dark {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .foregroundStyle(.thinMaterial)
            }
        }
        .padding(.horizontal)
    }
    
    private var placeholder: some View {
        VStack {
            HStack {
                ForEach(1...3, id: \.self) { _ in
                    greyHeart
                }
            }
            
            Image("Frog")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 200)
       
            Button {
                
            } label: {
                Text("feed.frog.button.placeholder")
            }
            .buttonStyle(FrogViewDisabledButtonStyle())
            .disabled(true)
        }
    }
    
    private func content(_ frog: FQFrog) -> some View {
        VStack {
            HStack {
                ForEach(1...3, id: \.self) { index in
                    if index <= frog.state.rawValue {
                        heart
                    } else {
                        greyHeart
                    }
                }
            }
            
            ZStack {
                Image(frog.state.frogImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 200)
            }
            
            frogStateButton(frog)
        }
    }
    
    private var heart: some View {
        Image("frogHeart")
            .resizable()
            .scaledToFit()
            .frame(height: 30)
    }
    
    private var greyHeart: some View {
        Image("frogHeartGrey")
            .resizable()
            .scaledToFit()
            .frame(height: 30)
    }
    
    
    
    @ViewBuilder
    private func frogStateButton(_ frog: FQFrog) -> some View {
        if frog.state == .great {
             Button {} label: {
                Text(FrogState.great.feedFrogButtonTitle)
            }
            .buttonStyle(FrogViewButtonStyle())
        } else {
             feedFrogButton(frog)
        }
    }
    
    @ViewBuilder
    private func feedFrogButton(_ frog: FQFrog) -> some View {
        if let earthCandy = earthCandyViewModel.earthCandy,
           !earthCandy.hasEnoughCandyForFeedFrog {
             notEnoughCandyButton
        } else {
             Button {
                guard frog.state != .great else { return }
                
                viewModel.send(.feedFrog)
            } label: {
                HStack {
                    Text(frog.state.feedFrogButtonTitle)
                    
                    Label {
                        Text("10.5")
                    } icon: {
                        Image("EarthCandy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15)
                    }
                }
            }
            .buttonStyle(FrogViewButtonStyle())
        }
    }
    
    private var notEnoughCandyButton: some View {
        Button {
            
        } label: {
            HStack {
                Text("frogView.notEnoughCandyButton.title")
                Label {
                    Text("10.5")
                } icon: {
                    Image("EarthCandy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 15)
                }
            }
        }
        .disabled(true)
        .buttonStyle(FrogViewDisabledButtonStyle())
    }
}



#Preview {
    FrogView(
        viewModel: .init(
            container: .init(
                services: StubService()
            ), notificationManager: NotificationManager()
        )
    )
    .environmentObject(NotificationManager())
    .environmentObject(
        EarthCandyViewModel(
            container: .init(
                services: StubService()
            )
        )
    )
}
