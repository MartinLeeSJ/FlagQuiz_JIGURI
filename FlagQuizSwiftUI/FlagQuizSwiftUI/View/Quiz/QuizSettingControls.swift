//
//  QuizSettingControls.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/6/24.
//

import SwiftUI

struct QuizSettingControls: View {
    @EnvironmentObject private var viewModel: QuizViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    @State private var quizCount: FQQuizCount = .ten
    @State private var quizOptionsCount: FQQuizOptionsCount = .four
    @State private var quizType: FQQuizType = .chooseNameFromFlag
    
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top, spacing: 16) {
                quizTypeMenu
                Divider()
                    .frame(height: 100)
                quizCountPicker
                Divider()
                    .frame(height: 100)
                quizItemCountPicker
            }
            
            
            Text("quizSettingControls.total.maximum.candy.description\(quizType.advantageCandy + quizCount.rawValue +  quizOptionsCount.advantageCandy)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.black)
                .padding(4)
                .frame(maxWidth: .infinity)
                .background(in: Capsule(style: .continuous))
                .backgroundStyle(.fqAccent)
                .padding(.horizontal)
            
            Button {
                viewModel.send(
                    .setNewQuiz(
                        count: quizCount,
                        optionsCount: quizOptionsCount,
                        quizType: quizType
                    )
                )
                navigationModel.navigate(to: QuizDestination.quiz)
            } label: {
                Text("start.quiz")
                    .font(.custom(FontName.pixel, size: 16))
            }
            .buttonStyle(QuizFilledButtonStyle(disabled: false))
        }
        .padding()
    }
    
    
    
    private var quizTypeMenu: some View {
        VStack {
            Text("quizIntro.quizTypeMenu.title")
                .font(.subheadline)
                .fontWeight(.medium)
           
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
            
            Text("quizSettingControls.quizType.extra.candy\(quizType.advantageCandy)")
                .font(.caption)
            
        }
        
    }
    
    private var quizCountPicker: some View {
        VStack(alignment: .center) {
            Text("quizIntro.quizCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
               

            
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
            
            Text("quizSettingControls.quizCount.candy\(quizCount.rawValue)")
                .font(.caption)
         
        }
        
    }
    
    private var quizItemCountPicker: some View {
        VStack(alignment: .center) {
            Text("quizIntro.quizItemCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
                
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
          
            Text("quizSettingControls.quizOptions.extra.candy\(quizType.advantageCandy)")
                .font(.caption)
        }
        
    }
}

#Preview {
    QuizSettingControls()
        .environmentObject(NavigationModel())
        .environmentObject(
            QuizViewModel(
                container: .init(
                    services: StubService()
                )
            )
        )
    
}
