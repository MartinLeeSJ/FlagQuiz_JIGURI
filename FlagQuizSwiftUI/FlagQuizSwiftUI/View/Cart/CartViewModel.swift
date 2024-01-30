//
//  CartViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import Foundation

final class CartViewModel: ObservableObject {
    @Published var cartItems: [FQItem] = []
    
    private let container: DIContainer
    
    init(
        cartItems: [FQItem],
        container: DIContainer
    ) {
        self.cartItems = cartItems
        self.container = container
    }
    
    
    func checkout() {
        
    }
    
}
