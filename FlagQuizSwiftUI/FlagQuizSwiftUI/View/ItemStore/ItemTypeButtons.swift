//
//  ItemTypeButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemTypeButtons: View {
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    @Namespace private var selectedButton
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(FQItemType.allCases, id: \.self) { type in
                    Button {
                        itemStoreViewModel.send(.selectType(type: type))
                    } label: {
                        Text(type.localizedName)
                            .foregroundStyle(.foreground)
                            .font(.caption)
                            .fontWeight(.semibold)
                    }
                    .padding(.bottom, 8)
                    .padding(.horizontal, 14)
                    .overlay {
                        if let selectedType = itemStoreViewModel.selectedType,
                           selectedType == type {
                            Line(.bottom)
                                .stroke(.fqAccent, lineWidth: 2)
                                .matchedGeometryEffect(id: "highlight", in: selectedButton)
                        }
                    }
                    .animation(.spring, value: itemStoreViewModel.selectedType)
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
        }
        .scrollIndicators(.hidden)
        .frame(idealHeight: 30, maxHeight: 40)
    }
}
