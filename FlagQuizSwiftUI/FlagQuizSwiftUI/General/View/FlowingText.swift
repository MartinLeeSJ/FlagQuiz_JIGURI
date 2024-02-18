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
    private let fadingColor: Color
    
    @State private var offset: CGFloat = 0.0
    @State private var isAnimating: Bool = false
    
    init(_ text: String, fadingColor: Color = .fqBg) {
        let string: String = Array(repeating: text + "   ", count: 3).joined(separator: "")
        self.originalText = text
        self.text = string
        self.fadingColor = fadingColor
    }

    var body: some View {
        GeometryReader { outerGeo in
            ScrollView(.horizontal) {
                Text(originalText)
                    .opacity(0)
                    .lineLimit(1, reservesSpace: true)
                    .overlay {
                        textOverlay(outerGeo)
                    }
                    .frame(maxHeight: .infinity)
                    .frame(minWidth: outerGeo.size.width, alignment: .center)
                    
            }
            .scrollDisabled(true)
            
        }
    }
    
    private func textOverlay(_ outerGeo: GeometryProxy) -> some View {
        GeometryReader { geo in
            if outerGeo.size.width > geo.size.width {
                staticText
            } else {
                animatingText(outerGeo)
            }
        }
    }
    
    private var staticText: some View {
        Text(originalText)
            .lineLimit(1)
    }
    
    private func animatingText(_ outerGeo: GeometryProxy) -> some View {
        ScrollView(.horizontal) {
            Text(text)
                .opacity(0)
                .lineLimit(1)
                .overlay {
                    GeometryReader { geo in
                        Text(text)
                            .offset(x: offset)
                            .onAppear {
                                if !isAnimating {
                                    flow(geo.size.width)
                                }
                            }
                            .onDisappear {
                                isAnimating = false
                            }
                    }
                }
        }
        .mask(alignment:.leading) {
            LinearGradient(
                stops: [
                    .init(color: .black, location: 0.75),
                    .init(color: .clear, location: 1)
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: outerGeo.size.width)
        }
        .scrollDisabled(true)
    }
    
    private func flow(_ width: CGFloat) {
        isAnimating = true
        
        let duration: TimeInterval = TimeInterval(Int(width / 100))
        let delay: TimeInterval = 4.0
        
        if #available(iOS 17.0, *) {
            withAnimation(.linear(duration: duration).delay(delay)) {
                offset -= width / 3
            } completion: {
                guard isAnimating else { return }
                offset = 0.0
                flow(width)
            }
        } else {
            withAnimation(.linear(duration: duration).delay(delay)) {
                offset -= width / 3
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + duration + delay + 0.5) {
                guard isAnimating else { return }
                offset = 0.0
                flow(width)
            }
            //TODO: OS버전이 낮은 경우에 completion 없이도 계속 실행 가능한지 연구
        }
    }
}

#Preview {
    FlowingText("Merry Christmas And Have a Happy new year Everything will be good so dont worry keep going")
        .padding()
}
