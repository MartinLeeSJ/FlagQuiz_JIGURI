//
//  InformationBalloon.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/4/24.
//

import SwiftUI

fileprivate struct Balloon: Shape {
    private let cornerRadius: CGFloat
    
    init(cornerRadius: CGFloat) {
        self.cornerRadius = cornerRadius
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let startY: CGFloat = rect.height / 2
        
        var balloonTipHeight: CGFloat = min(rect.width * 0.05, 20)
        balloonTipHeight = max(balloonTipHeight, 8)
        
        
        let halfOfBalloonTipWidth: CGFloat = balloonTipHeight * 0.65
        
        
        path.move(to: .init(x: 0, y: startY))
        path.addLine(
            to: .init(
                x: balloonTipHeight,
                y: startY + halfOfBalloonTipWidth
            )
        )
        path.addLine(
            to: .init(
                x: balloonTipHeight,
                y: rect.height - cornerRadius
            )
        )
        path.addQuadCurve(
            to: .init(x: balloonTipHeight + cornerRadius, y: rect.height),
            control: .init(x: balloonTipHeight, y: rect.height)
        )
        path.addLine(
            to: .init(
                x: rect.width - cornerRadius,
                y: rect.height
            )
        )
        path.addQuadCurve(
            to: .init(x: rect.width, y: rect.height - cornerRadius),
            control: .init(x: rect.width, y: rect.height)
        )
        path.addLine(
            to: .init(
                x: rect.width,
                y: cornerRadius
            )
        )
        path.addQuadCurve(
            to: .init(x: rect.width - cornerRadius, y: 0),
            control: .init(x: rect.width, y: 0)
        )
        path.addLine(to: .init(x: balloonTipHeight + cornerRadius, y: 0))
        path.addQuadCurve(
            to: .init(x: balloonTipHeight, y: cornerRadius),
            control: .init(x: balloonTipHeight, y: 0)
        )
        path.addLine(
            to: .init(
                x: balloonTipHeight,
                y: startY - halfOfBalloonTipWidth
            )
        )
        
        return path
    }
}

fileprivate struct InformationBalloon<Content>: View where Content: View {
    @Binding private var isPresented: Bool
    private let label: () -> Content
    private let cornerRadius: CGFloat
    private let balloonColor: Color
    
    
    init(
        isPresented: Binding<Bool>,
        balloonColor: Color,
        cornerRadius: CGFloat,
        @ViewBuilder label: @escaping () -> Content
    ) {
        self._isPresented = isPresented
        self.label = label
        self.balloonColor = balloonColor
        self.cornerRadius = cornerRadius
    }
    
    
    var body: some View {
        
        HStack {
            label()
        }
        .padding(.leading, 20)
        .padding(.trailing, 3)
        .padding(.vertical, 2)
        .background {
            Balloon(cornerRadius: cornerRadius)
                .foregroundStyle(balloonColor)
        }
        .onTapGesture {
            withAnimation(.spring) {
                isPresented = false
            }
        }
        .opacity(isPresented ? 1 : 0)
        
        
        
    }
}


extension View {
    func informationBalloon<Content: View>(
        isPresented: Binding<Bool>,
        ballonColor: Color,
        cornerRadius: CGFloat,
        @ViewBuilder label: @escaping () -> Content
    ) -> some View {
        HStack(spacing: 0) {
            self
 
            InformationBalloon(
                isPresented: isPresented,
                balloonColor: ballonColor,
                cornerRadius: cornerRadius,
                label: label
            )
            
        }
    }
    
}
