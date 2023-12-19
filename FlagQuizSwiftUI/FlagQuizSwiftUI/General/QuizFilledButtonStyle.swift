//
//  QuizFilledButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import SwiftUI


struct QuizFilledButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(scheme == .dark ? .bold : .medium)
            .foregroundStyle(scheme == .dark ? Color.black : Color.fqAccent)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(scheme == .dark ? Color.fqAccent : .black)
            }
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
    
    
}
