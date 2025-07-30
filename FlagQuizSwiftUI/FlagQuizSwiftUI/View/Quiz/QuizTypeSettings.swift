//
//  QuizTypeSettings.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/28/24.
//

import SwiftUI



struct QuizTypeSettings: View {
    @Binding private var quizType: FQQuizType
    
    init(quizType: Binding<FQQuizType>) {
        self._quizType = quizType
    }
    
    var body: some View {
            TabView(selection: $quizType) {
                ForEach(FQQuizType.allCases, id: \.self) { type in
                    Text(type.localizedShortenedTitle)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .font(.system(size: 21, weight: .bold))
                }
            }
            .quizSettingTab {
                title
            } topTrailingView: {
                difficulty
            } previousAction: {
                previousQuizType()
            } nextAction: {
                nextQuizType()
            }
            .onChange(of: quizType, perform: { 
                impactFeedback(ofQuizType: $0)
            })
          

    }
    
    private var title: some View {
        Text(
            String(
                localized: "quizTypeSettings.title",
                defaultValue: "Quiz Types"
            )
        )
    }
    
    @ViewBuilder
    private var difficulty: some View {
        let difficulty: Double = Double(quizType.difficulty.rawValue) / Double(FQQuizDifficulty.extreme.rawValue)
        Label {
            Text(
                String(
                    localized: "quizSettings.difficulty.title",
                    defaultValue: "Difficulty"
                )
            )
        } icon: {
            Image(systemName: "chart.bar.fill", variableValue: difficulty)
                .foregroundStyle(quizType.difficulty.color)
        }
    }
    
    private func nextQuizType() {
        guard let currentIndex = FQQuizType.allCases.firstIndex(of: self.quizType) else {
            return
        }
        
        let newIndex = FQQuizType.allCases.count <= currentIndex + 1 ? 0 : currentIndex + 1
        
        withAnimation {
            self.quizType = FQQuizType.allCases[newIndex]
        }
    }
    
    private func previousQuizType() {
        guard let currentIndex = FQQuizType.allCases.firstIndex(of: self.quizType) else {
            return
        }
        
        let newIndex = currentIndex == 0 ? FQQuizType.allCases.count - 1 : currentIndex - 1
        
        withAnimation {
            self.quizType = FQQuizType.allCases[newIndex]
        }
    }
    
    private func impactFeedback(ofQuizType currentQuizType: FQQuizType) {
        let feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle = switch currentQuizType {
        case .chooseNameFromFlag:
                .light
        case .chooseFlagFromName:
                .light
        case .chooseCaptialFromFlag:
                .heavy
        case .random:
                .heavy
        }
        
        UIImpactFeedbackGenerator(style: feedbackStyle)
        .impactOccurred()
    }
}



#if DEBUG

struct QuizTypeSettingsContainer: View {
    @State private var quizType: FQQuizType = .chooseCaptialFromFlag
    var body: some View {
        QuizTypeSettings(quizType: $quizType)
    }
}

#Preview {
    QuizTypeSettingsContainer()
}

#endif
