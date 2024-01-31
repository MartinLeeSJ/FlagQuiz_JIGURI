//
//  CartModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

final class CartModel: ObservableObject {
    @Published var items: [FQItem] = .init()
    
    enum Action {
        case checkout
        case addItemToCart(item: FQItem)
        case addWearingItemsToCart(items: [FQItem])
        case removeItem(FQItem)
    }
    
    var totalPrice: Int {
        items.reduce(0) {
            $0 + ($1.isOnEvent ? $1.specialPrice : $1.price)
        }
    }
    
    var discountedPrice: Int {
        Int(Double(totalPrice) * (1 - Double(FrogState.frogInGreatMoodDiscountPercentPoint) / 100))
    }
    
    
    private let container: DIContainer
    
    init(
        container: DIContainer
    ) {
        self.container = container
    }
    
    
    public func send(_ action: Action) {
        switch action {
        case .checkout: 
            checkout()
        case .addItemToCart(let item) :
            addToCart(item)
        case .addWearingItemsToCart(let items):
            addWearingItemsToCart(items)
        case .removeItem(let item):
            removeItem(item)
        }
    }
    
    private func removeItem(_ item: FQItem) {
        guard items.contains(item) else { return }
        
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
    
    //MARK: - Add To Cart
    
    private func addToCart(_ item: FQItem) {
        items.append(item)
        
//        toast = .init(
//            message: Localized.addedToCart(
//                item: localizedItemName(
//                    of: item,
//                    languageCode: code
//                )
//            )
//        )
    }
    
    //MARK: - Add Wearings To Cart
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addWearingItemsToCart(_ wearingItems: [FQItem]) {
        guard !wearingItems.isEmpty else { return }
        
        let cartSet = Set<FQItem>(items)
        
        /// 이미 장바구니에 있는 착용하고 잇는 옷 개수
        let alreadyInCartItemCount: Int = Set(wearingItems).intersection(cartSet).count
        
        if alreadyInCartItemCount != 0 {
            /// 이미 장바구니에 있는 착용하고 잇는 옷이 있다면
//            toast = .init(
//                message: Localized.addedWearingsToTheCartExcept(
//                    clothes: wearingItems.count - alreadyInCartItemCount
//                )
//            )
        } else {
            /// 장바구니에 있는 착용하고 잇는 옷이 없다면
//            toast = .init(
//                message: Localized.addedWearingsToTheCart(
//                    clothes: wearingItems.count
//                )
//            )
        }
        
        /// 장바구니에 추가하기
        items = Array(cartSet.union(wearingItems))
    }
    
    private func checkout() {
        
    }
    
}

// MARK: - Localization

fileprivate struct Localized  {
    static var cannotGetStoreItems: String {
        String(
            localized: "toastAlert.cannot.get.store.items",
            defaultValue: "Can not get items"
        )
    }
    
    static func changeCloth(from: [String], to: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.change.cloth.from.\(from.joined(separator: ", ")).to.\(to)"
        )
    }
    
    static func addedToCart(item: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.added.to.cart.\(item)"
        )
    }
    
    static var addWearingsInTheCart: String {
        String(localized: "itemStoreView.add.wearings.in.the.cart.button.title")
    }
    
    static func addedWearingsToTheCart(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart")
    }
    
    
    static func addedWearingsToTheCartExcept(clothes count: Int) -> String {
        String(localized: "itemStoreView.toastAlert.added.\(count).wearing.items.in.the.cart.except.already.exists")
    }
}
