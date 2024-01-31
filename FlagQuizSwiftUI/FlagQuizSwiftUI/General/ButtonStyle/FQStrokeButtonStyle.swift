//
//  FQStrokeButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/20/23.
//

import SwiftUI

struct FQStrokeButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var scheme
    private let disabled: Bool
    private let hasInfinityWidth: Bool
    
    
    init(
        disabled: Bool = false ,
        hasInfinityWidth: Bool = true
    ) {
        self.disabled = disabled
        self.hasInfinityWidth = hasInfinityWidth
    }
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if hasInfinityWidth { Spacer() }
            configuration.label
                .fontWeight(.medium)
                .padding()
            
            if hasInfinityWidth { Spacer() }
        }
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(scheme == .dark ? .black : .white)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(lineWidth: 1)
                .foregroundStyle(scheme == .dark ? Color.fqAccent : .black)
        }
        .overlay {
            if disabled {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(scheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
            }
        }
        .opacity(configuration.isPressed ? 0.5 : 1)
    }
    
   
}

