//
//  ItemStoreCartButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreCartButtons: View {
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    @EnvironmentObject private var toastModel: ItemStoreToast
    @EnvironmentObject private var cart: CartModel
    @Binding private var isCartViewPresented: Bool
    
    init(
        isCartViewPresented: Binding<Bool>
    ) {
        self._isCartViewPresented = isCartViewPresented
    }
    
    var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: .init(
                stops: [
                    .init(color: .clear, location: 0),
                    .init(color: .fqBg.opacity(0.05), location: 0.2),
                    .init(color: .fqBg, location: 0.7)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Button(action: addTriedOnItemsToCart) {
                Text(Localized.addWearingsInTheCart)
                    .font(.system(size: 14))
                    .padding(.horizontal, -12)
            }
            .buttonStyle(FQStrokeButtonStyle())
            .padding(.leading, 16)
            .padding(.top, 16)
            
            Button(action: goToCartViewToPay) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 14))
            }
            .buttonStyle(FQFilledButtonStyle(disabled: false, hasInfinityWidth: false))
            .padding(.trailing, 16)
            .padding(.top, 16)
            .overlay(alignment: .topTrailing) {
                itemsInTheCartCountBadge
            }
        }
        .padding(.top, 24)
        .padding(.bottom, 12)
        .background(in: .rect)
        .background(ignoresSafeAreaEdges: .all)
        .backgroundStyle(backgroundGradient)
        
    }
    
    @ViewBuilder
    private var itemsInTheCartCountBadge: some View {
        if !cart.items.isEmpty {
            Text(cart.items.count, format: .number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(6)
                .background(in: .circle)
                .backgroundStyle(.red)
                .padding(8)
        }
    }
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addTriedOnItemsToCart() {
        guard !itemStoreViewModel.triedOnItems.isEmpty else { return }
        cart.send(.addTheTriedOnItemsToCart(items: itemStoreViewModel.triedOnItems))
        toastModel.send(.addedTheTriedOnItems)
    }
    
    private func goToCartViewToPay() {
        isCartViewPresented = true
    }
}

fileprivate struct Localized {
    static var addWearingsInTheCart: String {
        String(localized: "itemStoreView.add.wearings.in.the.cart.button.title")
    }
}
