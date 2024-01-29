//
//  StoreItemGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct StoreItemGrid: View {
    @State private var selectedItem: FQItem?
    @State private var toast: ToastAlert?
  
    @Binding private var wearingItems: [FQItem]
    @Binding private var cartSet: Set<FQItem>
    @Binding private var isCartViewPresented: Bool
    private var currentTypeItems: [FQItem]
    private let languageCodeString: String
    
    init(
        wearingItems: Binding<[FQItem]>,
        cartSet: Binding<Set<FQItem>>,
        isCartViewPresented: Binding<Bool>,
        currentTypeItems: [FQItem],
        languageCodeString: String
    ) {
        self._wearingItems = wearingItems
        self._cartSet = cartSet
        self._isCartViewPresented = isCartViewPresented
        self.currentTypeItems = currentTypeItems
        self.languageCodeString = languageCodeString
    }
    
    private var colums: [GridItem] {
        Array<GridItem>(repeating: .init(.flexible(minimum: 64, maximum: 84)), count: 4)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums, alignment: .center) {
                ForEach(currentTypeItems, id: \.self) { item in
                    StoreItemCell(
                        selectedItem: $selectedItem,
                        item: item,
                        localizedItemName: localizedItemName(of: item)
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 60)
        }
        .overlay(alignment: .bottom) {
            ItemStoreCartButtons(
                wearingItems: $wearingItems,
                cartSet: $cartSet,
                toast: $toast,
                isCartViewPresented: $isCartViewPresented
            )
        }
        .toastAlert($toast)
        .sheet(item: $selectedItem) { item in
            ItemStoreSelectedItemView(
                selectedItem: $selectedItem,
                wearingItems: $wearingItems,
                cartSet: $cartSet,
                toast: $toast,
                item: item
            )
            
        }
    }
    
    func localizedItemName(of item: FQItem) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
}
