//
//  QuizCountSettings.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/28/24.
//

import SwiftUI

struct QuizCountSettings: View {
    @Binding private var quizCount: FQQuizCount
    
    init(quizCount: Binding<FQQuizCount>) {
        self._quizCount = quizCount
    }
    
    var body: some View {
        TabView(selection: $quizCount){
            ForEach(FQQuizCount.allCases, id: \.self) { count in
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
            previousQuizCount()
        } nextAction: {
            nextQuizCount()
        }
        .onChange(of: quizCount, perform: {
            impactFeedback(ofQuizCount: $0)
        })
    }
    
    private var title: some View {
        Text(
            String(
                localized: "quizCountSettings.title",
                defaultValue: "Quiz Count"
            )
        )
    }
    
    @ViewBuilder
    private var difficulty: some View {
        let difficulty: Double = Double(quizCount.difficulty.rawValue) / Double(FQQuizDifficulty.extreme.rawValue)
        Label {
            Text(
                String(
                    localized: "quizSettings.difficulty.title",
                    defaultValue: "Difficulty"
                )
            )
        } icon: {
            Image(systemName: "chart.bar.fill", variableValue: difficulty)
                .foregroundStyle(quizCount.difficulty.color)
        }
    }
    
    private func nextQuizCount() {
        guard let currentIndex = FQQuizCount.allCases.firstIndex(of: self.quizCount) else {
            return
        }
        
        let newIndex = FQQuizCount.allCases.count <= currentIndex + 1 ? 0 : currentIndex + 1
        
        withAnimation {
            self.quizCount = FQQuizCount.allCases[newIndex]
        }
    }
    
    private func previousQuizCount() {
        guard let currentIndex = FQQuizCount.allCases.firstIndex(of: self.quizCount) else {
            return
        }
        
        let newIndex = currentIndex == 0 ? FQQuizCount.allCases.count - 1 : currentIndex - 1
        
        withAnimation {
            self.quizCount = FQQuizCount.allCases[newIndex]
        }
    }
    
    private func impactFeedback(ofQuizCount currentQuizCount: FQQuizCount) {
        let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = switch currentQuizCount {
        case .five:
                .light
        case .ten:
                .medium
        case .fifteen:
                .heavy
        }
        
        UIImpactFeedbackGenerator(style: feedbackStyle)
        .impactOccurred()
    }
}


#if DEBUG

struct QuizCountSettingsContainer: View {
    @State private var quizCount: FQQuizCount = .five
    var body: some View {
        QuizCountSettings(quizCount: $quizCount)
    }
}

#Preview {
    QuizCountSettingsContainer()
}

#endif
