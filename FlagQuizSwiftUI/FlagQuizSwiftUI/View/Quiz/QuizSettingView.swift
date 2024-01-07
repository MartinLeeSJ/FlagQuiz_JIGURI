//
//  QuizSettingView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

enum QuizCount: Int, CaseIterable {
    case five = 5
    case ten = 10
    case fifteen = 15
}

enum QuizItemCount: Int, CaseIterable {
    case three = 3
    case four = 4
    case five = 5
}

struct QuizSettingView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: QuizViewModel
    
    
    init(viewModel: QuizViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.destinations) {
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                    .frame(height: 64)
                
                TypeWritingText(
                    originalText: String(localized: "quizSetting.intro"),
                    animation: .easeInOut
                )
                .font(.system(size: 50, design: .rounded))
                .fontWeight(.heavy)
                .padding(.horizontal)
                
                Spacer()
                
                Divider()
                
                QuizSettingControls()
                    .environmentObject(viewModel)

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

}







#Preview {
    QuizSettingView(viewModel: .init(container: .init(services: StubService())))
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}

