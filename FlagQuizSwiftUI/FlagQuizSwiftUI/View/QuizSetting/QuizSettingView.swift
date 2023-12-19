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
                originalText: String(localized: "QuizSetting-Intro", table: LocalizableTable.general),
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
                Text("StartQuiz", tableName: LocalizableTable.button)
            }
            .buttonStyle(QuizFilledButtonStyle())
            .padding()
            
        }
        
    }
    
    private var quizCountPicker: some View {
        HStack {
            Text("QuizIntro-QuizCountPicker-Title", tableName: LocalizableTable.general)
            
            Spacer()

            Picker("QuizIntro-QuizCountPicker-Title", selection: $viewModel.quizCount) {
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
            Text("QuizIntro-QuizItemCountPicker-Title",
                 tableName: LocalizableTable.general)
            
            Spacer()
            
            Picker("QuizIntro-QuizItemCountPicker-Title",
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

