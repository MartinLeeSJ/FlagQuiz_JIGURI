//
//  QuizView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI
import IsoCountryCodes

struct QuizView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var viewModel: QuizViewModel
    
    @State private var isReallyQuitAlertOn: Bool = false

    private var currentQuizRound: FQQuizRound {
        viewModel.quiz.currentQuizRound
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            QuizAnswer()
            
            QuizQuestion()
            
            QuizOptions()
            
            QuizSubmitButton()
                .animation(.smooth, value: viewModel.isSubmitted)
                .padding()
        }
        .task {
            viewModel.send(.loadCountryInfo)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    isReallyQuitAlertOn = true
                } label: {
                    Text("Quit")
                }
                
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                scoreView
                    .zIndex(1)
            }
            
        }
        .alert("really.quit.quiz", isPresented: $isReallyQuitAlertOn) {
            Button {
                navigationModel.toRoot()
            } label: {
                Text("Quit")
                    .foregroundStyle(Color.red)
            }
            
            Button {
                isReallyQuitAlertOn = false
            } label: {
                Text("Cancel")
            }
        }
        
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
    @StateObject var viewModel: QuizViewModel = .init(
        container: .init(services: StubService())
    )
    
    viewModel.send(.setNewQuiz(count: 10, optionCount: 3, quizType: .random))
    
    return NavigationStack {
        QuizView()
            .environmentObject(viewModel)
            .environmentObject(NavigationModel())
    }
}
