//
//  ItemStoreToast.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/31/24.
//

import Foundation

final class ItemStoreToast: ObservableObject {
    @Published var toast: ToastAlert?
    
    enum ToastAction {
        case cannotGetStoreItems
        case addedToCart
        case addedTheTriedOnItems
        case tryOnTheItem(hasDuplication: Bool)
    }
    
    public func send(_ toastAction: ToastAction) {
        toast =  switch toastAction {
        case .cannotGetStoreItems:
            .init(
                message: String(
                    localized: "itemStoreView.toastAlert.cannotGetStoreItems",
                    defaultValue: "Can not get items"
                )
            )
        case .addedToCart:
                .init(
                    message: String(
                        localized: "itemStoreView.toastAlert.addedToCart",
                        defaultValue: "Added the item to the cart"
                    )
                )
            
        case .addedTheTriedOnItems:
                .init(
                    message: String(
                        localized: "itemStoreView.toastAlert.addedTheTriedOnItems",
                        defaultValue: "Added the tried-on item to the cart"
                    )
                )
            
        case .tryOnTheItem(let hasDuplication):
            if hasDuplication {
                .init(
                    message: String(
                        localized: "itemStoreView.toastAlert.tryOnTheItem.hasDuplication",
                        defaultValue: "Trying on the item, taking off any duplicate items from the relevant category"
                    )
                )
            } else {
                .init(
                    message: String(
                        localized: "itemStoreView.toastAlert.tryOnTheItem",
                        defaultValue: "Trying on the item"
                    )
                )
            }
               
        }
    }
    
}


