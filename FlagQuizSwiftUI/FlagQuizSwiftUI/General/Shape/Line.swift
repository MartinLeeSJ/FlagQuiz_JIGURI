//
//  DottedLine.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/7/24.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let y = rect.size.height / 2
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}

