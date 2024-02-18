//
//  ItemStoreSelectedItemView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreSelectedItemView: View {
    @Environment(\.locale) private var locale
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    @EnvironmentObject private var cart: CartModel
    @EnvironmentObject private var toastModel: ItemStoreToast
    
    private let item: FQItem
    
    init(item: FQItem) {
        self.item = item
    }
    
    private var languageCodeString: String {
        guard let code = locale.language.languageCode?.identifier(.alpha2) else {
            return "en"
        }
        
        return code == "ko" ? code : "en"
        
    }
    
    private func localizedItemName(of item: FQItem) -> String {
        item.names.first {
            $0.languageCode == .init(rawValue: languageCodeString) ?? ServiceLangCode.EN
        }?.name ?? "No Data"
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(.thinMaterial)
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 150)
                .overlay {
                    StorageImageView(item.storageImagePath(equipped: false)) {
                        ProgressView()
                    }
                    .scaledToFit()
                }
        
            Text(localizedItemName(of: item))
          
            HStack {
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                
                Text(item.price, format: .number)
                    .font(.caption)
                    .overlay {
                        if item.isOnEvent {
                            Line()
                                .stroke(.red, lineWidth: 2)
                        }
                    }
                
                if item.isOnEvent {
                    Text(item.specialPrice, format: .number)
                        .font(.caption)
                        .padding(.leading, -4)
                }
            }
            .padding(.bottom, 32)
            
            
            HStack {
                let isWearing: Bool = itemStoreViewModel.triedOnItems.contains(where: { $0 == item })
                let isInTheCart: Bool = cart.items.contains { $0 == item }
                Button(action: tryOn) {
                    Text(isWearing ? Localized.alreadyWearing : Localized.tryOn)
                        .font(.subheadline)
                }
                .buttonStyle(
                    FQStrokeButtonStyle(
                        disabled: isWearing,
                        hasInfinityWidth: true
                    )
                )
                .disabled(isWearing)
                
                Spacer()
                    .frame(width: 16)
                
                Button(action: addToTheCart) {
                    Text(isInTheCart ? Localized.isInTheCart : Localized.addToCart)
                        .font(.subheadline)
                }
                .buttonStyle(
                    FQFilledButtonStyle(
                        disabled: isInTheCart,
                        hasInfinityWidth: true
                    )
                )
                .disabled(isInTheCart)
            }
            
        }
        .padding()
        .presentationDetents([.fraction(0.4)])
    }
    
    private func tryOn() {
        let hasDuplication: Bool = ItemStoreViewModel.hasAnyDuplicateOrRelevantCategoryInTheTriedOnItem(
            triedOnItems: itemStoreViewModel.triedOnItems,
            item
        )
        toastModel.send(.tryOnTheItem(hasDuplication: hasDuplication))
        
        itemStoreViewModel.send(.tryOn(item: item))
        dismiss()

    }
    
    private func addToTheCart() {
        cart.send(.addItemToTheCart(item: item))
        toastModel.send(.addedToCart)
        dismiss()
    }
}

fileprivate struct Localized {
    static var alreadyWearing: String {
        String(
            localized: "itemStoreView.already.wearing.button.title",
            defaultValue: "Already Wearing"
        )
    }
    
    static var tryOn: String {
        String(
            localized: "itemStoreView.try.on.button.title",
            defaultValue: "Try On"
        )
    }
    
   
    static var isInTheCart: String {
        String(
            localized: "itemStoreView.is.in.the.cart.button.title",
            defaultValue: "Is In The Cart"
        )
    }
    
    static var addToCart: String {
        String(
            localized: "itemStoreView.add.to.cart.button.title",
            defaultValue: "Add To Cart"
        )
    }
    
}
