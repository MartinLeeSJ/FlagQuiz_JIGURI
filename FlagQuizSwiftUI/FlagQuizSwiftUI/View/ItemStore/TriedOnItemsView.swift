//
//  TriedOnItemsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct TriedOnItemsView: View {
    @Environment(\.locale) private var locale
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(itemStoreViewModel.triedOnItems, id: \.self) { item in
                    Button {
                        itemStoreViewModel.send(.takeOff(item: item))
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
                            .stroke(.fqAccent, lineWidth: 1)
                    }
                    .animation(.easeInOut, value: itemStoreViewModel.triedOnItems)
                }
            }
            .safeAreaInset(edge: .leading) {}
        }
        .frame(idealHeight: 42, maxHeight: 45)
    }
    
    func localizedItemName(of item: FQItem) -> String {
        guard let languageCodeString = locale.language.languageCode?.identifier(.alpha2) else {
            return "No Data"
        }
        
        return item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
}


