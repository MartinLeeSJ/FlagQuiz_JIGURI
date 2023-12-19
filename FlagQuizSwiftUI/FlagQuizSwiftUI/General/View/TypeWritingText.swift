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
    private let gap: Double
    private let isInfinite: Bool
    
    
    init(originalText: String, animation: Animation? = nil, gap: Double = 0.3, isInfinite: Bool = true) {
        self.originalCharacters = originalText.split(separator: "").map { String($0) }
        self.animation = animation
        self.gap = gap
        self.isInfinite = isInfinite
    }
    
    func typeWrite(at position: Int) {
        guard position < originalCharacters.count else {
            if isInfinite {
                text = ""
                typeWrite(at: 0)
            }
            return
        }
        text.append(originalCharacters[position])
        
        DispatchQueue.main.asyncAfter(deadline: .now() + gap) {
            typeWrite(at: position + 1)
        }
    }

    
    var body: some View {
        Text(text)
            .animation(animation, value: text)
            .task {
                typeWrite(at: 0)
            }   
    }
}

