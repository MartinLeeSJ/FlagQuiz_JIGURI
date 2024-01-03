//
//  UserRankAccuracyGauge.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/3/24.
//

import SwiftUI

struct UserRankAccuracyGauge<Label>: View where Label: View {
    private let quizCount: Int?
    private let correctQuizCount: Int?
    private let accuracy: Double?
    
    private let title: () -> Label
    
    init(
        quizCount: Int?,
        correctQuizCount: Int?,
        accuracy: Double?,
        @ViewBuilder title: @escaping () -> Label
    ) {
        self.quizCount = quizCount
        self.correctQuizCount = correctQuizCount
        self.accuracy = accuracy
        self.title = title
    }
    var body: some View {
        VStack {
            title()
            Spacer()
            gauge
                .gaugeStyle(.accessoryCircular)
                .tint(
                    AngularGradient(
                        stops: [
                            .init(color: .red, location: 0.5),
                            .init(color: .orange, location: 0.6),
                            .init(color: .fqAccent, location: 1)
                        ],
                        center: .init(x: 0.5, y: 1)
                    )
                )
        }
    }
    
    @ViewBuilder
    private var gauge: some View {
        if let quizCount,
           let correctQuizCount,
           let accuracy {
            Gauge(
                value: Double(correctQuizCount),
                in: 0...Double(quizCount),
                label: {
                    Text("Accuracy")
                },
                currentValueLabel: { Text(String(format:"%.0f", accuracy * 100) + "%") },
                minimumValueLabel: { Text("0").bold().foregroundStyle(.red) },
                maximumValueLabel: { Text("100").bold().foregroundStyle(.green) }
            )
        } else {
            Gauge(
                value: 0.5,
                in: 0...1,
                label: {
                    Text("?")
                },
                currentValueLabel: { Text("?") },
                minimumValueLabel: { Text("0").bold().foregroundStyle(.red) },
                maximumValueLabel: { Text("100").bold().foregroundStyle(.green) }
            )
        }

    }
}

