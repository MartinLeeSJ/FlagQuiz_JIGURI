//
//  CartViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

final class CartViewModel: ObservableObject {
    enum Action {
        case checkout
        case removeItem(FQItem)
    }
    
    @Published var cartItems: [FQItem] = []
    
    var totalPrice: Int {
        cartItems.reduce(0) {
            $0 + ($1.isOnEvent ? $1.specialPrice : $1.price)
        }
    }
    
    var discountedPrice: Int {
        Int(Double(totalPrice) * (1 - Double(FrogState.frogInGreatMoodDiscountPercentPoint) / 100))
    }
    
    
    private let container: DIContainer
    
    init(
        cartItems: [FQItem],
        container: DIContainer
    ) {
        self.cartItems = cartItems
        self.container = container
    }
    
    
    public func send(_ action: Action) {
        switch action {
        case .checkout: 
            checkout()
        case .removeItem(let item):
            removeItem(item)
        }
    }
    
    private func removeItem(_ item: FQItem) {
        guard cartItems.contains(item) else { return }
        
        if let index = cartItems.firstIndex(of: item) {
            _ = withAnimation {
                cartItems.remove(at: index)
            }
        }
    }
    
    private func checkout() {
        
    }
    
}
