//
//  QuizView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import IsoCountryCodes

struct QuizView: View {
    @EnvironmentObject private var viewModel: QuizViewModel

    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    private var answerCountryFlagEmoji: String {
        let code = currentQuizRound.answerCountryCode.numericCode
        return IsoCountryCodes.find(key: code)?.flag ?? "정보없음"
    }
    
    private var flagImageUrl: URL? {
        if let country = viewModel.countries.first(where: {
            $0.id == currentQuizRound.answerCountryCode
        }) {
            return country.flagLinks.pngURL
        }
        return nil
    }
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            flagImage
            
            quizQuestion
            
            QuizOptionsGrid(viewModel: viewModel)
            
            QuizSubmitButton(viewModel: viewModel)
                .animation(.smooth, value: viewModel.isSubmitted)
                .padding()
        }
        .onChange(of: currentQuizRound) { value in
            
        }
        .onAppear {
            viewModel.send(.loadCountryInfo)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    
                } label: {
                    Text("Quit")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                scoreView
                    .zIndex(1)
            }
            
        }
        
    }
    
    @ViewBuilder
    private var flagImage: some View {
        Spacer()
        
        ZStack {
            URLImageView(flagImageUrl?.absoluteString) {
                Text(answerCountryFlagEmoji)
                    .font(.system(size: 96))
            }
            .scaledToFit()
            .frame(maxHeight: 100)
        }
        .frame(minHeight: 180, idealHeight: 180, maxHeight: 200)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: Rectangle())
        .padding(.bottom, 16)
    }
    
    private var quizQuestion: some View {
        HStack {
            Text("Q\(viewModel.quiz.currentQuizIndex + 1)")
                .padding()
                .background(.ultraThinMaterial,
                            in: RoundedRectangle(cornerRadius: 8))
                .padding(.trailing)
            
            Text("quizview.question")
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.leading)
        }
        .font(.subheadline)
        .padding()
        .background(.thickMaterial,
                    in: Rectangle())
        .overlay(alignment: .bottom) {
            let current = Float(viewModel.quiz.currentQuizIndex)
            let total = Float(viewModel.quiz.quizCount)
            
            ProgressView(value: .init(current/total))
                .animation(.easeIn(duration: 1.5), value: viewModel.quiz.currentQuizIndex)
                .progressViewStyle(.linear)
        }
        .padding(.vertical)
    }
    
    private var scoreView: some View {
         VStack(alignment: .leading) {
            let quiz = viewModel.quiz
             
            HStack {
                Text("current.quiz.description")
                Spacer()
                Text("current.quiz \(quiz.currentQuizIndex + 1) / \(quiz.quizCount)")
                    .fontWeight(.bold)
            }
            HStack {
                Text("correct.quiz.description")
                Spacer()
                Text("correct.quiz.count \(quiz.correctQuizRoundsCountBeforeCurrentRound)")
                    .fontWeight(.bold)
            }
            
            HStack {
                Text("wrong.quiz.description")
                Spacer()
                Text("wrong.quiz.count \(quiz.wrongQuizRoundsCountBeforeCurrentRound)")
                    .fontWeight(.bold)
            }
            
        }
        .monospacedDigit()
        .font(.footnote)
        .frame(minWidth: 80, idealWidth: 100, maxWidth: 240)
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .offset(y: 20)
    }
    
}


#Preview {
    @StateObject var viewModel: QuizViewModel = .init(container: .init(services: StubService()))
    
    viewModel.send(.setNewQuiz(count: 10, optionCount: 3))
    
    return NavigationStack {
        QuizView()
            .environmentObject(viewModel)
    }
}
