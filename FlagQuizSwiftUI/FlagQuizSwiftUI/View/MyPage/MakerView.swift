//
//  MakerView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/12/24.
//

import SwiftUI

struct MakerView: View {
    @Environment(\.colorScheme) private var scheme
    var body: some View {
        VStack(spacing: 8) {
            Text("Seok Jun Lee")
                .font(.custom(FontName.pixel, size: 30))
            Link(
                "Buy Me A Coffee ☕️",
                destination: .init(string: "https://www.buymeacoffee.com/martinleesj")!
            )
            .font(.custom(FontName.pixel, size: 20))
            Link(
                "Git Hub",
                destination: .init(string: "https://github.com/MartinLeeSJ")!
            )
            .font(.custom(FontName.pixel, size: 20))
          
        }
    }
}

struct MakerViewLabelContainer: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    
    private let size: CGFloat
    
    init(size: CGFloat) {
        self.size = size
    }
    
    func body(content: Content) -> some View {
        content
            .font(.custom(FontName.pixel, size: size))
            .foregroundStyle(scheme == .dark ? .black: .white)
            .padding(8)
            .background(
                scheme == .dark ? .white: .black,
                in: RoundedRectangle(cornerRadius: 10)
            )
    }
}

extension View {
    func makerViewLabelContainer(fontSize: CGFloat) -> some View {
        self
            .modifier(MakerViewLabelContainer(size: fontSize))
    }
}

#Preview {
    MakerView()
}
