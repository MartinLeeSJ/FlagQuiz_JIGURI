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
            Button(action: addWearingItemsToCart) {
                Text(Localized.addWearingsInTheCart)
            }
            .buttonStyle(FQStrokeButtonStyle())
            .padding(.leading, 16)
            .padding(.top, 16)
            
            Button(action: goToCartViewToPay) {
                Image(systemName: "cart.fill")
                    .font(.title3)
            }
            .buttonStyle(FQFilledButtonStyle(disabled: false, hasInfinityWidth: false))
            .padding(.trailing, 16)
            .padding(.top, 16)
            .overlay(alignment: .topTrailing) {
                itemsInTheCartCountBadge
            }
        }
        .padding(.top, 24)
        .background(in: .rect)
        .background(ignoresSafeAreaEdges: .all)
        .backgroundStyle(backgroundGradient)
        
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
                .padding(8)
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

#Preview {
    GeometryReader { geo in
        Rectangle()
            .foregroundStyle(.white)
            .ignoresSafeArea()
        
        
        VStack {
            Spacer()
            ItemStoreCartButtons(
                wearingItems: .constant([]),
                cartSet: .constant(Set(FQItem.mockItems)),
                toast: .constant(nil),
                isCartViewPresented: .constant(false)
            )
        }
        
    }
   
 
}
