//
//  QuizSettingView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI



struct QuizSettingView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel = QuizSettingViewModel()

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
                    viewModel.destinations.append(QuizDestination.quiz)
                } label: {
                    Text("start.quiz")
                }
                .buttonStyle(QuizFilledButtonStyle(disabled: false))
                .padding()
                
            }
            .navigationDestination(for: QuizDestination.self) { destination in
                switch destination {
                case .quiz:
                    QuizView(
                        viewModel: QuizViewModel(
                            container: container,
                            quizCount: viewModel.quizCount.rawValue,
                            quizOptionsCount: viewModel.quizItemCount.rawValue
                        )
                    )
                    .environmentObject(viewModel)
                case .quizResult(let quiz):
                    Text(quiz.quizRounds.map{ $0.answerCountryCode.numericCode }.joined(separator: ", "))

                }
            }
            
        }
        
    }
    
    private var quizCountPicker: some View {
        HStack {
            Text("quizIntro.quizCountPicker.title")
            
            Spacer()

            Picker("quizIntro.quizCountPicker.title",
                   selection: $viewModel.quizCount
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
                   selection: $viewModel.quizItemCount
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
    QuizSettingView()
}

