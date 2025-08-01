//
//  QuizSettingTabViewModifier.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/28/24.
//

import SwiftUI

struct QuizSettingTabViewModifier<TL: View, TT: View>: ViewModifier {
    
    let topLeadingView: () -> TL
    let topTrailingView: () -> TT
    let previousAction: () -> Void
    let nextAction: () -> Void
    
    init(
        @ViewBuilder topLeadingView: @escaping () -> TL,
        @ViewBuilder topTrailingView: @escaping () -> TT,
        previousAction: @escaping () -> Void,
        nextAction: @escaping () -> Void
    ) {
        self.topLeadingView = topLeadingView
        self.topTrailingView = topTrailingView
        self.previousAction = previousAction
        self.nextAction = nextAction
    }
    
    func body(content: Content) -> some View {
        content
            .tabViewStyle(.page(indexDisplayMode: .never))
            .overlay {
                Capsule(style: .continuous)
                    .stroke(.fqAccent, lineWidth: 2.0)
            }
            .overlay {
                HStack {
                    Button(action: previousAction) {
                        Text("<")
                    }
                    Spacer()
                    Button(action: nextAction) {
                        Text(">")
                    }
                }
                .font(.custom(FontName.pixel, size: 40))
                .padding()
            }
            .overlay(alignment: .topLeading) {
                topLeadingView()
                    .padding(.leading, 48)
                    .padding(.top, 6)
                    .font(.system(size: 12))
                    
            }
            .overlay(alignment: .topTrailing) {
                topTrailingView()
                .padding(.trailing, 48)
                .padding(.top, 6)
                .font(.system(size: 12))
                
            }
            .frame(height: 70)
    }
}

extension View {
    func quizSettingTab<TL: View, TT: View>(
        @ViewBuilder topLeadingView: @escaping () -> TL,
        @ViewBuilder topTrailingView: @escaping () -> TT,
        previousAction: @escaping () -> Void,
        nextAction: @escaping () -> Void
    ) -> some View {
        self.modifier(
                QuizSettingTabViewModifier(
                    topLeadingView: topLeadingView,
                    topTrailingView: topTrailingView,
                    previousAction: previousAction,
                    nextAction: nextAction
                )
            )
    }
}
