//
//  ItemTypeButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemTypeButtons: View {
    @Binding private var selectedType: FQItemType?
    @Namespace private var selectedButton
    
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
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 14)
                    .overlay {
                        if selectedType == type {
                            Line(.bottom)
                                .stroke(.fqAccent, lineWidth: 2)
                                .matchedGeometryEffect(id: "highlight", in: selectedButton)
                        }
                    }
                    .animation(.spring, value: selectedType)
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
        }
        .scrollIndicators(.hidden)
        .frame(idealHeight: 30, maxHeight: 40)
    }
}
