//
//  StoreItemGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct StoreItemGrid: View {
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    @State private var selectedItem: FQItem? = nil
    
    private let isLandscape: Bool
    
    init(isLandscape: Bool = false) {
        self.isLandscape = isLandscape
    }

    private var currentTypeItems: [FQItem] {
        return itemStoreViewModel.storeItems.filter { $0.type == itemStoreViewModel.selectedType }
    }
    
    private var colums: [GridItem] {
        Array<GridItem>(repeating: .init(.flexible(minimum: 64, maximum: 84)), count: isLandscape ? 3 : 4)
    }
    
    var body: some View {
        ScrollView {
            if currentTypeItems.isEmpty {
                VStack {
                    Spacer()
                        .frame(height: 64)
                    Text(
                        String(
                            localized: "itemStoreView.there.are.no.items",
                            defaultValue: "There are currently no items listed."
                        )
                    )
                        .font(.caption)
                }
                .frame(maxWidth: .infinity)
            } else {
                grid
            }
        }
        .sheet(item: $selectedItem) { item in
            ItemStoreSelectedItemView(item: item)
        }
    }
    
    private var grid: some View {
        LazyVGrid(columns: colums, alignment: .center) {
            ForEach(currentTypeItems, id: \.self) { item in
                let isOwnedItem: Bool = itemStoreViewModel.userItemsOfType[item.type]?.contains(where: { $0.id == item.id }) ?? false
                
                StoreItemCell(item: item)
                    .overlay(alignment: .topLeading) {
                        if isOwnedItem {
                            ownedBadge
                        }
                    }
                    .onTapGesture {
                        if !isOwnedItem {
                            selectedItem = item
                        }
                    }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 120)
    }
    
    private var ownedBadge: some View {
        Text(
            String(
                localized: "storeItemCell.owned.item.description",
                defaultValue: "Owned"
            )
        )
        .font(.caption2)
        .fontWeight(.medium)
        .foregroundStyle(.white)
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(in: .capsule)
        .backgroundStyle(.red)
        .padding(4)
    }
 
}
