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
    
    @State private var quizCount: QuizCount = .ten
    @State private var quizItemCount: QuizItemCount = .four
    @State private var quizType: FQQuizType = .chooseNameFromFlag
    
    var estimatedEarthCandy: Double {
        let quizCountPoint = Double(quizCount.rawValue)
        let quizOptionPoint = Double(quizItemCount.rawValue) / 10.0
        return quizCountPoint * quizOptionPoint + quizType.advantagePoint
    }
    
    
    var body: some View {
        VStack(spacing: 16) {
            
            quizTypeMenu
            
            quizCountPicker
            
            quizItemCountPicker
            
//            estimatedEarthCandyView
            
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
    }
    
    private var estimatedEarthCandyView: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text("Estimated")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
            
            HStack(spacing: 8) {
                VStack {
                    Text("\(quizCount.rawValue)")
                        .font(.headline)
                    Text("Quiz Count")
                        .font(.system(size: 8))
                        .fontWeight(.medium)
                }
                
                Image(systemName: "multiply")
                
                VStack {
                    Text("0.\(quizItemCount.rawValue)")
                        .font(.headline)
                    Text("Quiz Options / 10")
                        .font(.system(size: 8))
                        .fontWeight(.medium)
                }
                
                Image(systemName: "plus")
                
                VStack {
                    Text(quizType.advantagePoint, format: .number)
                        .font(.headline)
                    Text("Type advantage")
                        .font(.system(size: 8))
                        .fontWeight(.medium)
                }
                
                Image(systemName: "equal")
                
                VStack {
                    Text(estimatedEarthCandy, format: .number)
                        .font(.headline)
                    Text("Earth Candy")
                        .font(.system(size: 8))
                        .fontWeight(.medium)
                }
                
                Spacer()
                
            }
        }
        .padding(.horizontal)
        
    }
    
    private var quizTypeMenu: some View {
        HStack {
            Text("quizIntro.quizTypeMenu.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
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
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .menuStyle(.button)
        }
        .padding(.horizontal)
    }
    
    private var quizCountPicker: some View {
        HStack {
            Text("quizIntro.quizCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Picker("quizIntro.quizCountPicker.title",
                   selection: $quizCount
            ) {
                ForEach(QuizCount.allCases, id: \.self) { quizCount in
                    Text("\(quizCount.rawValue)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .tag(quizCount)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 180)
        }
        .padding(.horizontal)
    }
    
    private var quizItemCountPicker: some View {
        HStack {
            Text("quizIntro.quizItemCountPicker.title")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
            
            Picker("quizIntro.quizItemCountPicker.title",
                   selection: $quizItemCount
            ) {
                ForEach(QuizItemCount.allCases, id: \.self) { quizItemCount in
                    Text("\(quizItemCount.rawValue)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .tag(quizItemCount)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 180)
        }
        .padding(.horizontal)
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
