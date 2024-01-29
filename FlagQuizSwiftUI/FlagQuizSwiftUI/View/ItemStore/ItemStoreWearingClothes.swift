//
//  ItemStoreWearingClothes.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreWearingClothes: View {
    @Binding private var wearingItems: [FQItem]
    private let languageCodeString: String
    
    init(wearingItems: Binding<[FQItem]>, languageCodeString: String) {
        self._wearingItems = wearingItems
        self.languageCodeString = languageCodeString
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(wearingItems, id: \.self) { item in
                    Button {
                        if let index = wearingItems.firstIndex(where: { $0 == item }) {
                            _ = withAnimation {
                                wearingItems.remove(at: index)
                            }
                        }
                    } label: {
                        Text(localizedItemName(of: item))
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                    }
                    .font(.caption)
                    .foregroundStyle(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(in: .rect(cornerRadius: 4, style: .continuous))
                    .backgroundStyle(.fqAccent.opacity(0.35))
                    .animation(.easeInOut, value: wearingItems)
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


