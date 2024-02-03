//
//  ItemStoreView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/28/24.
//

import SwiftUI

struct ItemStoreView: View {
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
        .navigationTitle(
            String(
                localized: "itemStoreView.title",
                defaultValue: "Store"
            )
        )
        .navigationBarTitleDisplayMode(.inline)
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


#Preview {
    let container = DIContainer(services: StubService())
    return NavigationStack {
        ItemStoreView(
            itemStoreViewModel: .init(container: container),
            cart: .init(container: container)
        )
    }
}
