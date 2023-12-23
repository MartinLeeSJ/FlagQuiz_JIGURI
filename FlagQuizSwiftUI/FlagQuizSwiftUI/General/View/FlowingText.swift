//
//  FlowingText.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/23/23.
//

import SwiftUI

struct FlowingText: View {
    private let originalText: String
    private let text: String
    
    @State private var offset: CGFloat = 0.0
    
    init(_ text: String) {
        let string: String = Array(repeating: text + "   ", count: 3).joined(separator: "")
        self.originalText = text + "   "
        self.text = string
    }

    var body: some View {
        Text(originalText)
            .opacity(0)
            .lineLimit(1)
            .overlay {
                GeometryReader { geo in
                    ScrollView(.horizontal) {
                        Text(text)
                            .opacity(0)
                            .lineLimit(1)
                            .overlay {
                                GeometryReader { geo in
                                    Text(text)
                                        .offset(x: offset)
                                        .onAppear {
                                            flow(geo.size.width)
                                        }
                                }
                            }
                    }
                    .scrollDisabled(true)
                }
            }
        
        
    }
    
    private func flow(_ width: CGFloat) {
        
        let duration: TimeInterval = TimeInterval(Int(width / 100))
        let delay: UInt64 = 5_000_000_000
        
        if #available(iOS 17.0, *) {
            withAnimation(.linear(duration: duration)) {
                offset -= width / 3
            } completion: {
                Task {
                    offset = 0.0
                    try await Task.sleep(nanoseconds: delay)
                    flow(width)
                }
            }
        } else {
            withAnimation(.linear(duration: duration)) {
                offset -= width / 3
            }
            //TODO: OS버전이 낮은 경우에 completion 없이도 계속 실행 가능한지 연구
        }
    }
}

#Preview {
    FlowingText("Merry Christmas!")
}
