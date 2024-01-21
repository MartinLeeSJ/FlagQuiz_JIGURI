//
//  FrogViewButtonStyle.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/10/24.
//

import SwiftUI

struct FrogViewButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(.white)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(in: Capsule(style: .continuous))
            .backgroundStyle(.fqHeart)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}

struct FrogViewDisabledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundStyle(.white)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(in: Capsule(style: .continuous))
            .backgroundStyle(.tertiary)
    }
}
