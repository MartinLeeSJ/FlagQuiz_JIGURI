//
//  QuizSettingControls.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/6/24.
//

import SwiftUI

struct QuizSettingControls: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: QuizViewModel
    @AppStorage("didthequiz") private var didTheQuiz: Bool = false
    
    @State private var quizCount: FQQuizCount = .ten
    @State private var quizOptionsCount: FQQuizOptionsCount = .four
    @State private var quizType: FQQuizType = .chooseNameFromFlag
    
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 16) {
                controls
                totalEarthCandyDescription
            }
            .padding(8)
            .overlay {
                startQuizFirstView
            }
            startQuizButton
        }
        .padding()
    }
    
    
    @ViewBuilder
    private var controls: some View {
        QuizTypeSettings(quizType: $quizType)
        QuizCountSettings(quizCount: $quizCount)
        QuizOptionsCountSettings(quizOptionsCount: $quizOptionsCount)
    }
    
    @ViewBuilder
    private var startQuizFirstView: some View {
        if !didTheQuiz {
            VStack(spacing: 16) {
                Text(
                    String(
                        localized: "quizSettingControls.quiz.first",
                        defaultValue: "Shall we just start the quiz first?"
                    )
                )
                Image(systemName: "arrow.down")
            }
            .font(.headline)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.ultraThinMaterial)
            }
        }
    }
    
    private var totalEarthCandyDescription: some View {
        Text("quizSettingControls.total.maximum.candy.description\(quizType.advantageCandy + quizCount.rawValue +  quizOptionsCount.advantageCandy)")
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(.black)
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(in: Capsule(style: .continuous))
            .backgroundStyle(.fqAccent)
            .padding(.horizontal)
    }
    
    private var startQuizButton: some View {
        Button {
            if !didTheQuiz {
                didTheQuiz = true
            }
            viewModel.send(
                .setNewQuiz(
                    count: quizCount,
                    optionsCount: quizOptionsCount,
                    quizType: quizType
                )
            )
            container.navigationModel.navigate(to: QuizDestination.quiz)
        } label: {
            Text("start.quiz")
                .font(.custom(FontName.pixel, size: 16))
        }
        .buttonStyle(FQFilledButtonStyle(disabled: false))
    }
}

#Preview {
    QuizSettingControls()
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(
            QuizViewModel(
                container: .init(
                    services: StubService()
                )
            )
        )
    
}
