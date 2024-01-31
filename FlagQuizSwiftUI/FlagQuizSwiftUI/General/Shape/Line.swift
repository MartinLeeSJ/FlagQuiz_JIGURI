//
//  DottedLine.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/7/24.
//

import SwiftUI

struct Line: Shape {
    enum Placement {
        case top
        case middle
        case bottom
    }
    
    private let placement: Placement
    
    init(_ placement: Placement = .middle) {
        self.placement = placement
    }
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let y: CGFloat = switch placement {
        case .top: .zero
        case .middle: rect.size.height / 2
        case .bottom: rect.size.height
        }
        
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}

