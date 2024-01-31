//
//  FQFilledButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import SwiftUI


struct FQFilledButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    
    private var disabled: Bool
    private let isLightModeOnly: Bool
    private let hasInfinityWidth: Bool
    
    init(
        disabled: Bool,
        isLightModeOnly: Bool = false,
        hasInfinityWidth: Bool = true
    ) {
        self.disabled = disabled
        self.isLightModeOnly = isLightModeOnly
        self.hasInfinityWidth = hasInfinityWidth
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
        HStack {
            if hasInfinityWidth {
                Spacer()
            }
            configuration.label
                .fontWeight(fontWeight)
                .foregroundStyle(labelColor)
                .padding()
            if hasInfinityWidth {
                Spacer()
            }
        }
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
