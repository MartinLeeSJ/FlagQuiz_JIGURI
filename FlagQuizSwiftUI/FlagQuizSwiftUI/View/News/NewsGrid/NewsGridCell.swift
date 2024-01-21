//
//  NewsGridCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct NewsGridCell<Content>: View where Content: View {
    private let alignment: HorizontalAlignment
    private let title: LocalizedStringKey
    private let content: () -> Content
    
    init(
        alignment: HorizontalAlignment = .center,
        title: LocalizedStringKey,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.title = title
        self.content = content
    }
    
    var body: some View {
        
        VStack(alignment: alignment, spacing: 0) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(Color(uiColor: .label))
            
            Divider()
                .padding(.vertical, 8)
            
            Spacer()
            
            
            content()
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(Color(uiColor: .tertiaryLabel))
                        .imageScale(.small)
                        .offset(x: 4)
                }
            
            Spacer()
            
        }
        .padding(12)
        .background(.thinMaterial, in: Rectangle())
        
        
        
    }
}
