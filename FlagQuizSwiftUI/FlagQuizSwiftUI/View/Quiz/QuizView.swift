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
                currentEarthCandyView
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

    private var currentEarthCandyView: some View {
        HStack {
            let quiz = viewModel.quiz
         
            Text("quizView.current.earthcandy.description")
            HStack {
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
          
                Text(
                    quiz.correctQuizRoundsCountBeforeCurrentRound,
                    format: .number
                )
                .fontWeight(.bold)
            }
            .frame(minWidth: 60, alignment: .leading)
            .padding(8)
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .monospacedDigit()
        }
        .font(.footnote)
        
       
        
    }
    
}


#Preview {
    @StateObject var viewModel: QuizViewModel = .init(
        container: .init(services: StubService())
    )
    
    viewModel.send(
        .setNewQuiz(
            count: .ten,
            optionsCount: .three,
            quizType: .random
        )
    )
    
    return NavigationStack {
        QuizView()
            .environmentObject(viewModel)
            .environmentObject(NavigationModel())
    }
}
