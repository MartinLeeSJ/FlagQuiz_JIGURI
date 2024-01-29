//
//  ItemStoreCartButtons.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreCartButtons: View {
    @Binding private var wearingItems: [FQItem]
    @Binding private var cartSet: Set<FQItem>
    @Binding private var toast: ToastAlert?
    @Binding private var isCartViewPresented: Bool
    
    init(
        wearingItems: Binding<[FQItem]>,
        cartSet: Binding<Set<FQItem>>,
        toast: Binding<ToastAlert?>,
        isCartViewPresented: Binding<Bool>
    ) {
        self._wearingItems = wearingItems
        self._cartSet = cartSet
        self._toast = toast
        self._isCartViewPresented = isCartViewPresented
    }
    
    var body: some View {
        HStack {
            Button(action: addWearingItemsToCart) {
                Text(Localized.addWearingsInTheCart)
            }
            
            Button(action: goToCartViewToPay) {
                Text(Localized.goToPayItems)
            }
            .padding(8)
            .overlay(alignment: .topTrailing) {
                itemsInTheCartCountBadge
            }
            
        }
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder
    private var itemsInTheCartCountBadge: some View {
        if !cartSet.isEmpty {
            Text(cartSet.count, format: .number)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(6)
                .background(in: .circle)
                .backgroundStyle(.red)
        }
    }
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addWearingItemsToCart() {
        guard !wearingItems.isEmpty else { return }
        
        /// 이미 장바구니에 있는 착용하고 잇는 옷 개수
        let alreadyInCartItemCount: Int = Set(wearingItems).intersection(cartSet).count
        
        if alreadyInCartItemCount != 0 {
            /// 이미 장바구니에 있는 착용하고 잇는 옷이 있다면
            toast = .init(
                message: Localized.addedWearingsInTheCartExcept(
                    clothes: wearingItems.count - alreadyInCartItemCount
                )
            )
        } else {
            /// 장바구니에 있는 착용하고 잇는 옷이 없다면
            toast = .init(
                message: Localized.addedWearingsInTheCart(
                    clothes: wearingItems.count
                )
            )
        }

        /// 장바구니에 추가하기
        cartSet.formUnion(wearingItems)
    }
    
    private func goToCartViewToPay() {
        isCartViewPresented = true
    }
}

fileprivate struct Localized {
    static var addWearingsInTheCart: String {
        String(localized: "itemStoreView.add.wearings.in.the.cart.button.title")
    }
    
    static var goToPayItems: String {
        String(localized: "itemStoreView.go.to.cart.view.to.pay.button.title")
    }
    
    static func addedWearingsInTheCart(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart")
    }
    
    static func addedWearingsInTheCartExcept(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart.except.already.exists")
    }
}
