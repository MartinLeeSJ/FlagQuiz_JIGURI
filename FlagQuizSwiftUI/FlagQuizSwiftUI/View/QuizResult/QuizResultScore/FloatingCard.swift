//
//  FloatingCard.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/7/24.
//

import SwiftUI

struct FloatingCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .background(
                in: RoundedRectangle(
                    cornerRadius: 12,
                    style: .continuous
                )
            )
            .backgroundStyle(.ultraThinMaterial)
            .padding(.horizontal, 16)
    }
}

extension View {
    func floadingCard() -> some View {
        self.modifier(FloatingCard())
    }
}
