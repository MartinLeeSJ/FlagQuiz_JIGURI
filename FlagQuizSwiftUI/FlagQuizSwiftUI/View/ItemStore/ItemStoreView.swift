//
//  ItemStoreView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import SwiftUI

struct ItemStoreView: View {
    @Environment(\.locale) var locale
    @Environment(\.dismiss) var dismiss
    @StateObject private var itemStoreViewModel: ItemStoreViewModel
    @StateObject private var cart: CartModel
    @StateObject private var toastModel = ItemStoreToast()
    
    @State private var isCartViewPresented: Bool = false
    
    
    init(
        itemStoreViewModel: ItemStoreViewModel,
        cart: CartModel
    ) {
        self._itemStoreViewModel = StateObject(wrappedValue: itemStoreViewModel)
        self._cart = StateObject(wrappedValue: cart)
    }
    
    private var languageCodeString: String {
        guard let code = locale.language.languageCode?.identifier(.alpha2) else {
            return "en"
        }
        if code == "ko" {
            return code
        }
        
        return "en"
    }
    
    
    var body: some View {
        GeometryReader { geo in
            Group {
                if geo.size.width < geo.size.height {
                    verticalContent
                } else {
                    horizontalContent
                }
            }
            .blur(radius: isCartViewPresented ? 3 : 0)
            .disabled(isCartViewPresented)
 
            if isCartViewPresented {
                Rectangle()
                    .fill(.clear)
                    .onTapGesture {
                        if isCartViewPresented {
                            isCartViewPresented = false
                        }
                    }
                CartView(isCartViewPresented: $isCartViewPresented)
            }
        }
        .task {
            do {
                try await itemStoreViewModel.load()
            } catch {
                toastModel.send(.cannotGetStoreItems)
            }
        }
        .navigationBarBackButtonHidden()
        .environmentObject(itemStoreViewModel)
        .environmentObject(cart)
        .environmentObject(toastModel)
        .toastAlert($toastModel.toast)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EarthCandyView(isShowingInStoreView: true)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text(String(localized: "itemStoreView.quit", defaultValue: "Quit"))
                        .fontWeight(.medium)
                }
            }
        }
    }
    
    func localizedItemName(of item: FQItem) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
    
    private var verticalContent: some View {
        VStack {
            ItemStoreFrogView()
            
            TriedOnItemsView()
            
            ItemTypeButtons()
            
            Divider()
                .padding(.horizontal)
            
            StoreItemGrid()
            .overlay(alignment: .bottom) {
                ItemStoreCartButtons(
                    isCartViewPresented: $isCartViewPresented
                )
            }
        }
    }
    
    private var horizontalContent: some View {
        HStack {
            VStack {
                ItemStoreFrogView()
                
                TriedOnItemsView()
            }
            VStack {
                ItemTypeButtons()
                
                Divider()
                    .padding(.horizontal)
                
                StoreItemGrid()
                .overlay(alignment: .bottom) {
                    ItemStoreCartButtons(
                        isCartViewPresented: $isCartViewPresented
                    )
                }
            }
        }
    }
}

