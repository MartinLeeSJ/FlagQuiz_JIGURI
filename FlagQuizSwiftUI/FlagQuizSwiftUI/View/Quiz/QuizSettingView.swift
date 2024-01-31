//
//  QuizSettingView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI


struct QuizSettingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: QuizViewModel
    
    
    init(viewModel: QuizViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.destinations) {
            GeometryReader { geo in
                if geo.size.width < geo.size.height {
                    verticalContent
                } else {
                    horizontalContent(geo.size.width)
                }
                
            }
            .navigationDestination(for: QuizDestination.self) { destination in
                Group {
                    switch destination {
                    case .quiz:
                        QuizView()
                            .environmentObject(viewModel)
                    case .quizResult(let quiz):
                        QuizResultView(quizResult: quiz)
                            .environmentObject(viewModel)
                    case .countryDetail(let countryCode):
                        CountryDetailView(viewModel: .init(container: container,
                                                           countryCode: countryCode))
                    }
                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
    
    private var verticalContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            introTitle
            
            Spacer()
            
            Divider()
                .overlay {
                    Text(
                        String(
                            localized:"quizSettingView.quiz.setting.title",
                            defaultValue:"Setting up a quiz"
                        )
                    )
                    .font(.custom(FontName.pixel, size: 16))
                    .background(.background)
                }
            
            quizSettingControls
        }
    }
    
    private func horizontalContent(_ width: CGFloat) -> some View {
        HStack {
            introTitle
                .frame(width: width / 2, alignment: .leading)
            
            VStack(alignment: .leading) {
                Spacer()
                
                Text(
                    String(
                        localized:"quizSettingView.quiz.setting.title",
                        defaultValue:"Setting up a quiz"
                    )
                )
                .font(.custom(FontName.pixel, size: 16))
                .background(.background)
                
                
                quizSettingControls
            }
            .frame(width: width / 2)
        }
    }
    
    private var introTitle: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 64)
            
            TypeWritingText(
                originalText: String(localized: "quizSetting.intro"),
                animation: .easeInOut
            ) {
                //TODO: 추가적인 애니메이션 실행
            }
            .font(.custom(FontName.pixel, size: 40))
            .padding(.horizontal)
        }
    }
    
    private var quizSettingControls: some View {
        QuizSettingControls()
            .environmentObject(viewModel)
    }
    
}


#Preview {
    QuizSettingView(viewModel: .init(container: .init(services: StubService())))
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}

