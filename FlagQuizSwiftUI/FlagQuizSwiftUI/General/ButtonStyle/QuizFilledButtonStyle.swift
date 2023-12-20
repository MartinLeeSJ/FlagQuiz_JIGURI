//
//  QuizFilledButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import SwiftUI


struct QuizFilledButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    
    private var disabled: Bool
    
    init(disabled: Bool) {
        self.disabled = disabled
    }
    
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
            .overlay {
                if disabled {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color.white.opacity(0.5))
                }
            }
    }
}
