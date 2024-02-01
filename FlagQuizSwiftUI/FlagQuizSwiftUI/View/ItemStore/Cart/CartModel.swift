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
        case addItemToTheCart(item: FQItem)
        case addTheTriedOnItemsToCart(items: [FQItem])
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
        case .addItemToTheCart(let item) :
            addToCart(item)
        case .addTheTriedOnItemsToCart(let items):
            addTheTriedOnItemsToCart(items)
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
    }
    
    //MARK: - Add Wearings To Cart
    
    /// 이미 입고 있는 옷을 장바구니에 추가하는 함수
    private func addTheTriedOnItemsToCart(_ wearingItems: [FQItem]) {
        guard !wearingItems.isEmpty else { return }
        
        let cartSet = Set<FQItem>(items)
        
        /// 이미 장바구니에 있는 착용하고 잇는 옷 개수
        let alreadyInCartItemCount: Int = Set(wearingItems).intersection(cartSet).count
        
        
        /// 장바구니에 추가하기
        items = Array(cartSet.union(wearingItems))
    }
    
    private func checkout() {
        
    }
    
}
