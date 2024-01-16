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
    private let isLightModeOnly: Bool
    
    init(disabled: Bool, isLightModeOnly: Bool = false) {
        self.disabled = disabled
        self.isLightModeOnly = isLightModeOnly
    }
    
    private var fontWeight: Font.Weight {
        guard !isLightModeOnly else { return .medium }
        return scheme == .light ? .medium : .bold
    }
    
    private var labelColor: Color {
        guard !isLightModeOnly else { return Color.fqAccent }
        return scheme == .light ?  Color.fqAccent : Color.black
    }
    
    private var buttonBg: Color {
        guard !isLightModeOnly else { return .black }
        return scheme == .light ?  Color.black : Color.fqAccent
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .fontWeight(fontWeight)
            .foregroundStyle(labelColor)
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(buttonBg)
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
