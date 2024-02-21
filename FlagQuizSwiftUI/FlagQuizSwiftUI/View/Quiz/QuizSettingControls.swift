//
//  QuizSettingControls.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/6/24.
//

import SwiftUI

struct QuizSettingControls: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: QuizViewModel
    @AppStorage("didthequiz") private var didTheQuiz: Bool = false
    
    @State private var quizCount: FQQuizCount = .ten
    @State private var quizOptionsCount: FQQuizOptionsCount = .four
    @State private var quizType: FQQuizType = .chooseNameFromFlag
    
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                VStack(spacing: 20) {
                   controlPane
                    
                    Text("quizSettingControls.total.maximum.candy.description\(quizType.advantageCandy + quizCount.rawValue +  quizOptionsCount.advantageCandy)")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.black)
                        .padding(4)
                        .frame(maxWidth: .infinity)
                        .background(in: Capsule(style: .continuous))
                        .backgroundStyle(.fqAccent)
                        .padding(.horizontal)
                }
                .overlay {
                    if !didTheQuiz {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundStyle(.ultraThinMaterial)
                    }
                }
                
                if !didTheQuiz {
                    VStack(spacing: 16) {
                        Text(
                            String(
                                localized: "quizSettingControls.quiz.first",
                                defaultValue: "Shall we just start the quiz first?"
                            )
                        )
                        Image(systemName: "arrow.down")
                    }
                    .font(.headline)
                }
            }
            
            Button {
                if !didTheQuiz {
                    didTheQuiz = true
                }
                viewModel.send(
                    .setNewQuiz(
                        count: quizCount,
                        optionsCount: quizOptionsCount,
                        quizType: quizType
                    )
                )
                container.navigationModel.navigate(to: QuizDestination.quiz)
            } label: {
                Text("start.quiz")
                    .font(.custom(FontName.pixel, size: 16))
            }
            .buttonStyle(FQFilledButtonStyle(disabled: false))
        }
        .padding()
    }
    
    @ViewBuilder
    private var controlPane: some View {
        HStack(alignment: .top, spacing: 16) {
            quizTypeMenu
            Divider()
                .frame(height: 100)
            quizCountPicker
            Divider()
                .frame(height: 100)
            quizItemCountPicker
        }
    }
    
    private var quizTypeMenu: some View {
        VStack {
            Text("quizIntro.quizTypeMenu.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
            if #available(iOS 17.0, *) {
                Picker(
                    "quizIntro.quizTypeMenu.title",
                    selection: $quizType) {
                        ForEach(FQQuizType.allCases, id: \.self) { quizType in
                            Text(quizType.localizedShortenedTitle)
                                .font(.custom(FontName.pixel, size: 15))
                                .fontWeight(.medium)
                            
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxHeight: 100)
            } else {
                Picker(
                    "quizIntro.quizTypeMenu.title",
                    selection: $quizType) {
                        ForEach(FQQuizType.allCases, id: \.self) { quizType in
                            Text(quizType.localizedShortenedTitle)
                                .font(.custom(FontName.pixel, size: 15))
                                .fontWeight(.medium)
                            
                        }
                    }
            }
            
            Text("quizSettingControls.quizType.extra.candy\(quizType.advantageCandy)")
                .font(.caption)
            
        }
        
    }
    
    private var quizCountPicker: some View {
        VStack(alignment: .center) {
            Text("quizIntro.quizCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
            
            if #available(iOS 17.0, *) {
                Picker("quizIntro.quizCountPicker.title",
                       selection: $quizCount
                ) {
                    ForEach(FQQuizCount.allCases, id: \.self) { quizCount in
                        Text("\(quizCount.rawValue)")
                            .font(.custom(FontName.pixel, size: 30))
                            .fontWeight(.medium)
                            .tag(quizCount)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 100)
            } else {
                Picker("quizIntro.quizCountPicker.title",
                       selection: $quizCount
                ) {
                    ForEach(FQQuizCount.allCases, id: \.self) { quizCount in
                        Text("\(quizCount.rawValue)")
                            .font(.custom(FontName.pixel, size: 30))
                            .fontWeight(.medium)
                            .tag(quizCount)
                    }
                }
            }
            
            Text("quizSettingControls.quizCount.candy\(quizCount.rawValue)")
                .font(.caption)
            
        }
        
    }
    
    private var quizItemCountPicker: some View {
        VStack(alignment: .center) {
            Text("quizIntro.quizItemCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
            if #available(iOS 17.0, *) {
                Picker("quizIntro.quizItemCountPicker.title",
                       selection: $quizOptionsCount
                ) {
                    ForEach(FQQuizOptionsCount.allCases, id: \.self) { quizItemCount in
                        Text("\(quizItemCount.rawValue)")
                            .font(.custom(FontName.pixel, size: 30))
                            .fontWeight(.medium)
                            .tag(quizItemCount)
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxHeight: 100)
            } else {
                Picker("quizIntro.quizItemCountPicker.title",
                       selection: $quizOptionsCount
                ) {
                    ForEach(FQQuizOptionsCount.allCases, id: \.self) { quizItemCount in
                        Text("\(quizItemCount.rawValue)")
                            .font(.custom(FontName.pixel, size: 30))
                            .fontWeight(.medium)
                            .tag(quizItemCount)
                    }
                }
            }
            
            Text("quizSettingControls.quizOptions.extra.candy\(quizOptionsCount.advantageCandy)")
                .font(.caption)
        }
        
    }
}

#Preview {
    QuizSettingControls()
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(
            QuizViewModel(
                container: .init(
                    services: StubService()
                )
            )
        )
    
}
