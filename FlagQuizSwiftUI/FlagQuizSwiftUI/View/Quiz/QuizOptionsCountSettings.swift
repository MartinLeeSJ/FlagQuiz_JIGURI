//
//  QuizOptionsCountSettings.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/28/24.
//

import SwiftUI

struct QuizOptionsCountSettings: View {
    @Binding private var quizOptionsCount: FQQuizOptionsCount
    
    init(quizOptionsCount: Binding<FQQuizOptionsCount>) {
        self._quizOptionsCount = quizOptionsCount
    }
    
    var body: some View {
        TabView(selection: $quizOptionsCount){
            ForEach(FQQuizOptionsCount.allCases, id: \.self) { count in
                Text("\(count.rawValue)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .font(.system(size: 21, weight: .bold))
            }
        }
        .quizSettingTab {
            title
        } topTrailingView: {
            difficulty
        } previousAction: {
            previousQuizOptionsCount()
        } nextAction: {
            nextQuizOptionsCount()
        }
        .onChange(of: quizOptionsCount, perform: {
            impactFeedback(ofQuizOptionsCount: $0)
        })
    }
    
    private var title: some View {
        Text(
            String(
                localized: "quizOptionsCountSettings.title",
                defaultValue: "Quiz Options Count"
            )
        )
    }
    
    @ViewBuilder
    private var difficulty: some View {
        let difficulty: Double = Double(quizOptionsCount.difficulty.rawValue) / Double(FQQuizDifficulty.extreme.rawValue)
        Label {
            Text(
                String(
                    localized: "quizSettings.difficulty.title",
                    defaultValue: "Difficulty"
                )
            )
        } icon: {
            Image(systemName: "chart.bar.fill", variableValue: difficulty)
                .foregroundStyle(quizOptionsCount.difficulty.color)
        }
    }
    
    private func nextQuizOptionsCount() {
        guard let currentIndex = FQQuizOptionsCount.allCases.firstIndex(of: self.quizOptionsCount) else {
            return
        }
        
        let newIndex = FQQuizOptionsCount.allCases.count <= currentIndex + 1 ? 0 : currentIndex + 1
        
        withAnimation {
            self.quizOptionsCount = FQQuizOptionsCount.allCases[newIndex]
        }
    }
    
    private func previousQuizOptionsCount() {
        guard let currentIndex = FQQuizOptionsCount.allCases.firstIndex(of: self.quizOptionsCount) else {
            return
        }
        
        let newIndex = currentIndex == 0 ? FQQuizOptionsCount.allCases.count - 1 : currentIndex - 1
        
        withAnimation {
            self.quizOptionsCount = FQQuizOptionsCount.allCases[newIndex]
        }
    }
    
    private func impactFeedback(ofQuizOptionsCount currentQuizQoptionsCount: FQQuizOptionsCount) {
        let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = switch currentQuizQoptionsCount {
        case .three:
                .light
        case .four:
                .medium
        case .five:
                .heavy
        }
        
        UIImpactFeedbackGenerator(style: feedbackStyle)
        .impactOccurred()
    }
}


