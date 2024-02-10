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
    private let colorSchemeMode: ColorSchemeMode
    private let hasInfinityWidth: Bool
    
    enum ColorSchemeMode {
        case lightOnly
        case darkOnly
        case both
    }
    
    init(
        disabled: Bool,
        colorSchemeMode: ColorSchemeMode = .both,
        hasInfinityWidth: Bool = true
    ) {
        self.disabled = disabled
        self.colorSchemeMode = colorSchemeMode
        self.hasInfinityWidth = hasInfinityWidth
    }
    
    private var fontWeight: Font.Weight {
        if colorSchemeMode == .lightOnly {
            return .medium
        }
        
        if colorSchemeMode == .darkOnly {
            return .bold
        }
        
        return scheme == .light ? .medium : .bold
    }
    
    private var labelColor: Color {
        if colorSchemeMode == .lightOnly {
            return Color.fqAccent
        }
        
        if colorSchemeMode == .darkOnly {
            return Color.black
        }
        
        return scheme == .light ?  Color.fqAccent : Color.black
    }
    
    private var buttonBg: Color {
        if colorSchemeMode == .lightOnly {
            return Color.black
        }
        
        if colorSchemeMode == .darkOnly {
            return Color.fqAccent
        }
        
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
