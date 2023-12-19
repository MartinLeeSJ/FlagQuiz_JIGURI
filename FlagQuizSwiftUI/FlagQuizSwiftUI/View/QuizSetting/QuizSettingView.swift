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
                originalText: "국기보고\n나라 맞추기\n퀴즈",
                animation: .bouncy,
                gap: 0.2,
                isInfinite: false
            )
            .font(.system(size: 64))
            .fontWeight(.heavy)
            .padding(.horizontal)
            
            Spacer()
        
            HStack {
                Text("퀴즈 문항 수")
                Spacer()
                
                Picker("퀴즈 문항 수", selection: $viewModel.quizCount) {
                    ForEach(QuizCount.allCases, id: \.self) { quizCount in
                        Text("\(quizCount.rawValue)")
                            .tag(quizCount)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 200)
            }
            .padding(.horizontal)
            
            HStack {
                Text("퀴즈 선택지 수")
                
                Spacer()
                
                Picker("퀴즈 선택지 수", selection: $viewModel.quizItemCount) {
                    ForEach(QuizItemCount.allCases, id: \.self) { quizItemCount in
                        Text("\(quizItemCount.rawValue)")
                            .tag(quizItemCount)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 200)
            }
            .padding(.horizontal)
            
            Button {
                
            } label: {
                Text("퀴즈 시작하기")
                    .padding()
                    .frame(maxWidth: .infinity)
            }
            .background {
                RoundedRectangle(cornerRadius: 8)
            }
            .padding()
            
        }
        
    }
}



#Preview {
    QuizSettingView()
    
}

