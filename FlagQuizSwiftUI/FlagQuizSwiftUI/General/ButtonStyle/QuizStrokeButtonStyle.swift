//
//  QuizStrokeButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct QuizStrokeButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(.medium)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(scheme == .dark ? Color.fqAccent : .black)
            }
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

