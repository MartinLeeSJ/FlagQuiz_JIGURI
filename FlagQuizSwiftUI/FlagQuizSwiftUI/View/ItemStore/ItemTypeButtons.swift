//
//  ItemTypeButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemTypeButtons: View {
    @Binding private var selectedType: FQItemType?
    
    init(selectedType: Binding<FQItemType?>) {
        self._selectedType = selectedType
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(FQItemType.allCases, id: \.self) { type in
                    Button {
                       selectedType = type
                    } label: {
                        Text(type.localizedName)
                            .foregroundStyle(.foreground)
                            .font(.caption)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background {
                        Capsule(style: .continuous)
                            .stroke(
                                selectedType == type ? .fqAccent : .gray,
                                lineWidth: selectedType == type ? 2 : 1
                            )
                    }
                    .animation(.easeInOut, value: selectedType)
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
        }
        .scrollIndicators(.hidden)
        .frame(idealHeight: 42, maxHeight: 45)
    }
}
