//
//  QuizOptionButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizOptionButtonStyle: ButtonStyle {
    private let isSelected: Bool
    
    init(isSelected: Bool) {
        self.isSelected = isSelected
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(4)
            .frame(minHeight: 100, idealHeight: 100, maxHeight: 200)
            .frame(maxWidth: .infinity)
            .background(in: RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1.5)
                    .foregroundStyle(isSelected ? Color.fqAccent : Color.fqQuizOptionGrey)
            }
    }
}


enum QuizSubmission {
    case correct
    case wrongSubmitted
    case none
}

struct QuizOptionResultButtonStyle: ButtonStyle {
    private let submission: QuizSubmission
    
    private var strokeColor: Color {
        switch submission {
        case .correct: Color.blue
        case .wrongSubmitted: Color.red
        case .none: Color.fqQuizOptionGrey
        }
    }
    
    private var imageName: String? {
        switch submission {
        case .correct:
            "checkmark.circle.fill"
        case .wrongSubmitted:
            "x.circle.fill"
        case .none:
            nil
        }
    }
    
    init(submission: QuizSubmission) {
        self.submission = submission
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(4)
            .frame(minHeight: 100)
            .frame(maxWidth: .infinity)
            .background(in: RoundedRectangle(cornerRadius: 10))
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1.5)
                    .foregroundStyle(strokeColor)
            }
            .overlay(alignment: .topTrailing) {
                if let imageName {
                    Image(systemName: imageName)
                        .imageScale(.medium)
                        .foregroundStyle(strokeColor)
                        .offset(x: -10, y: 10)
                }
            }
    }
}
