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
    @StateObject private var viewModel: QuizViewModel
    
    @State private var quizCount: QuizCount = .ten
    @State private var quizItemCount: QuizItemCount = .four
    
    init(viewModel: QuizViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack(path: $viewModel.destinations) {
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
            
                quizCountPicker
                
                quizItemCountPicker
                
                Button {
                    viewModel.send(.setNewQuiz(count: quizCount.rawValue,
                                               optionCount: quizItemCount.rawValue))
                    viewModel.send(.navigate(to: .quiz))
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
                case .countryDetail(_):
                    Text("detail")
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
}







#Preview {
    QuizSettingView(viewModel: .init(container: .init(services: StubService())))
}

