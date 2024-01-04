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
    
    @State private var quizCount: QuizCount = .ten
    @State private var quizItemCount: QuizItemCount = .four
    @State private var quizType: FQQuizType = .chooseNameFromFlag
    
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
                    animation: .bouncy
                )
                .font(.system(size: 64))
                .fontWeight(.heavy)
                .padding(.horizontal)
                
                Spacer()
                
                Divider()
                
                quizTypeMenu
                
                quizCountPicker
                
                quizItemCountPicker
                
                Button {
                    viewModel.send(
                        .setNewQuiz(
                            count: quizCount.rawValue,
                            optionCount: quizItemCount.rawValue,
                            quizType: quizType
                        )
                    )
                    navigationModel.navigate(to: QuizDestination.quiz)
                } label: {
                    Text("start.quiz")
                }
                .buttonStyle(QuizFilledButtonStyle(disabled: false))
                .padding()
                
            }
            .navigationDestination(for: QuizDestination.self) { destination in
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
        }
    }
    
    private var quizCountPicker: some View {
        HStack {
            Text("quizIntro.quizCountPicker.title")
            
            Spacer()
            
            Picker("quizIntro.quizCountPicker.title",
                   selection: $quizCount
            ) {
                ForEach(QuizCount.allCases, id: \.self) { quizCount in
                    Text("\(quizCount.rawValue)")
                        .tag(quizCount)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
        }
        .padding(.horizontal)
    }
    
    private var quizItemCountPicker: some View {
        HStack {
            Text("quizIntro.quizItemCountPicker.title")
            
            Spacer()
            
            Picker("quizIntro.quizItemCountPicker.title",
                   selection: $quizItemCount
            ) {
                ForEach(QuizItemCount.allCases, id: \.self) { quizItemCount in
                    Text("\(quizItemCount.rawValue)")
                        .tag(quizItemCount)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 200)
        }
        .padding(.horizontal)
    }
    
    private var quizTypeMenu: some View {
        HStack {
            Text("quizIntro.quizTypeMenu.title")
            
            Spacer()
            
            Menu {
                ForEach(FQQuizType.allCases, id: \.self) { quizType in
                    Button {
                        self.quizType = quizType
                    } label: {
                        HStack {
                            Text(quizType.localizedShortenedTitle)
                            Spacer()
                            if self.quizType == quizType {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Label(quizType.localizedTitle, systemImage: "chevron.down.square.fill")
                    .fontWeight(.medium)
            }
            .menuStyle(.button)
        }
        .padding(.horizontal)
    }
    
    
}







#Preview {
    QuizSettingView(viewModel: .init(container: .init(services: StubService())))
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}

