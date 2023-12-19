//
//  QuizSettingView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct QuizSettingView: View {
    @StateObject private var viewModel = QuizSettingViewModel()
   
    var body: some View {
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
                
            } label: {
                Text("start.quiz")
            }
            .buttonStyle(QuizFilledButtonStyle())
            .padding()
            
        }
        
    }
    
    private var quizCountPicker: some View {
        HStack {
            Text("quizIntro.quizCountPicker.title")
            
            Spacer()

            Picker("", selection: $viewModel.quizCount) {
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
            
            Picker("",
                   selection: $viewModel.quizItemCount) {
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

