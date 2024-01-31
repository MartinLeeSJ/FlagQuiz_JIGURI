//
//  ItemStoreWearingClothes.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreWearingClothes: View {
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    private let languageCodeString: String
    
    init(languageCodeString: String) {
        self.languageCodeString = languageCodeString
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(itemStoreViewModel.wearingItems, id: \.self) { item in
                    Button {
                        // TODO: 뷰모델에 Take Off 만들기
//                        if let index = wearingItems.firstIndex(where: { $0 == item }) {
//                            _ = withAnimation {
//                                wearingItems.remove(at: index)
//                            }
//                        }
                    } label: {
                        Text(localizedItemName(of: item))
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                    .font(.caption)
                    .foregroundStyle(.foreground)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(.fqAccent, lineWidth: 2)
                    }
                    .animation(.easeInOut, value: itemStoreViewModel.wearingItems)
                }
            }
            .safeAreaInset(edge: .leading) {}
        }
        .frame(idealHeight: 42, maxHeight: 45)
    }
    
    func localizedItemName(of item: FQItem) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
}


