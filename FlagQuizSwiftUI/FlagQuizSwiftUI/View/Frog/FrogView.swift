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
    @EnvironmentObject private var newsViewModel: NewsViewModel
    @EnvironmentObject private var frogModel: FrogModel
    
    var body: some View {
        VStack(spacing: 16) {
            if let frog = frogModel.frog {
                content(frog)
            } else {
                placeholder
            }
            
            FrogMenuView()
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topTrailing) {
            FrogSettlementIcon(frog: frogModel.frog)
        }
        .padding()
        .task {
            frogModel.observe()
        }
        .background {
            if scheme == .dark {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
            }
        }
        
    }
    
    private var placeholder: some View {
        VStack {
            HStack {
                ForEach(1...3, id: \.self) { _ in
                    greyHeart
                }
            }
            
            Image("frogSoSo")
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
                guard let isAnonymous = newsViewModel.isAnonymousUser() else {
                    return
                }
                
                if isAnonymous {
                    newsViewModel.setLinkingLocation(.frogStateButton)
                } else {
                    frogModel.send(.feedFrog)
                }
            } label: {
                HStack {
                    Text(frog.state.feedFrogButtonTitle)
                    
                    Label {
                        Text(
                            FQEarthCandy.earthCandyPointForFeedingFrog,
                            format: .number
                        )
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
                    Text(
                        FQEarthCandy.earthCandyPointForFeedingFrog,
                        format: .number
                    )
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
    FrogView()
        .environmentObject(FrogModel(container: .init(services: StubService()), notificationManager: NotificationManager()))
        .environmentObject(NotificationManager())
        .environmentObject(
            EarthCandyViewModel(
                container: .init(
                    services: StubService()
                )
            )
        )
}
