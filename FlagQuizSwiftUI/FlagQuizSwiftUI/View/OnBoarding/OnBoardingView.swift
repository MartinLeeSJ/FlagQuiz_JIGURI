//
//  OnBoardingView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI



struct OnBoardingView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var story: OnBoardingStory = .one
    @State private var didReadStory: Bool = false

    var body: some View {
        NavigationStack(path: $navigationModel.destinations) {
            stroyContent
                .navigationDestination(for: OnBoardingDestination.self) { destination in
                    switch destination {
                    case .createUserName: 
                        CreateUserNameView(
                            viewModel: .init(container: container)
                        )
                    case .createFrog:
                        CreateFrogView(
                            viewModel: .init(container: container)
                        )
                        
                    case .attDescription:
                        ATTDescriptionView()
                    }
                }
        }
    }
    
    private var stroyContent: some View {
        VStack {
            TabView(selection: $story) {
                ForEach(OnBoardingStory.allCases, id: \.self) { current in
                    GeometryReader { geo in
                        let size = geo.size
                        
                        if size.width < size.height {
                            portraitStoryContent(currentStory: current)
                        } else {
                            landscapeStoryContent(currentStory: current)
                        }
                    }
                    
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            
            Button {
                guard story != .three else {
                    toCreateUserNameView()
                    return
                }
                
                next()
            } label: {
                Text("onboarding.next")
            }
            .buttonStyle(QuizFilledButtonStyle(disabled: false))
            
            Spacer()
                .frame(height: 30)
                .frame(maxWidth: .infinity)
                .overlay {
                    if story != .three {
                        Button {
                            toCreateUserNameView()
                        } label: {
                            Text("onboarding.skip")
                        }
                       
                    }
                    
                }
        }
        .padding(.horizontal)
    }
    
    private func portraitStoryContent(currentStory current: OnBoardingStory) -> some View {
        VStack {
            Image(current.imageNameOfColorScheme(scheme == .dark))
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .padding(.top, 128)
              
            Spacer()
            
            TypeWritingText(
                originalText: current.lettersForPortrait,
                latency: 0.06
            )
            .font(.custom(FontName.pixel, size: 18))
            .lineSpacing(10.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 64)
        }
    }
    
    private func landscapeStoryContent(currentStory current: OnBoardingStory) -> some View {
        ZStack {
            Image(current.imageNameOfColorScheme(scheme == .dark))
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(0.1)

            TypeWritingText(
                originalText: current.lettersForLandscape,
                latency: 0.06
            )
            .font(.custom(FontName.pixel, size: 20))
            .lineSpacing(10.0)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
    
    private func next() {
        guard story != .three else { return }
        story = OnBoardingStory(rawValue: story.rawValue + 1)!
    }
    
    private func toCreateUserNameView() {
        navigationModel.navigate(to: OnBoardingDestination.createUserName)
    }
}

enum OnBoardingStory: Int, Hashable, CaseIterable {
    case one = 0
    case two
    case three
    
    var lettersForPortrait: String {
        switch self {
        case .one:
            String(localized: "onboarding.story.one")
        case .two:
            String(localized: "onboarding.story.two")
        case .three:
            String(localized: "onboarding.story.three")
        }
    }
    
    var lettersForLandscape: String {
        switch self {
        case .one:
            String(localized: "onboarding.story.one.landscape")
        case .two:
            String(localized: "onboarding.story.two.landscape")
        case .three:
            String(localized: "onboarding.story.three.landscape")
        }
    }
    
    
    func imageNameOfColorScheme(_ isDarkMode: Bool) -> String {
        switch self {
        case .one:
            isDarkMode ? "frogEarthEyeBBg" : "frogEarthEyeWBg"
        case .two:
            isDarkMode ? "frogSweatBBg" : "frogSweatWBg"
        case .three:
            isDarkMode ? "frogStudyHardBBg" : "frogStudyHardWBg"
        }
    }
    
}

#Preview {
    OnBoardingView()
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}
