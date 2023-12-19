//
//  TypeWritingText.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import SwiftUI

struct TypeWritingText: View {
    @State private var text: String = ""

    private let originalCharacters: [String]
    private let animation: Animation?
    private let latency: Double
    private let isInfinite: Bool
   
    
    init(
        originalText: String,
        animation: Animation? = nil,
        latency: Double = 0.3,
        isInfinite: Bool = false,
        gap: Int = 3
    ) {
        let spacing: String = Array(repeating: " ", count: gap).reduce("", +)
        self.originalCharacters = (originalText + spacing).split(separator: "").map { String($0) }
        self.animation = animation
        self.latency = latency
        self.isInfinite = isInfinite
    }
    
    private func typeWrite(at position: Int) {
        guard position < originalCharacters.count,
              text.count < originalCharacters.count else {
            if isInfinite {
                text = ""
                typeWrite(at: 0)
            }
            return
        }
        text.append(originalCharacters[position])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            typeWrite(at: position + 1)
        }
    }

    
    var body: some View {
        Text(text)
            .animation(animation, value: text)
            .task {
                if text.isEmpty {
                    typeWrite(at: 0)
                }
            }
      
    }
}

