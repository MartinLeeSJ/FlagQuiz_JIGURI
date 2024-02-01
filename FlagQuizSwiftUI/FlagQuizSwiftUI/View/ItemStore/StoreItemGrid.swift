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

    private var currentTypeItems: [FQItem] {
        guard let selectedType = itemStoreViewModel.selectedType else { return [] }
        
        return itemStoreViewModel.storeItems.filter { $0.type == selectedType }
                
    }
    
    private var colums: [GridItem] {
        Array<GridItem>(repeating: .init(.flexible(minimum: 64, maximum: 84)), count: 4)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, alignment: .center) {
                ForEach(currentTypeItems, id: \.self) { item in
                    StoreItemCell(item: item)
                    .onTapGesture {
                        selectedItem = item
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 120)
        }
        .sheet(item: $selectedItem) { item in
            ItemStoreSelectedItemView(item: item)
        }
    }
    
 
}
