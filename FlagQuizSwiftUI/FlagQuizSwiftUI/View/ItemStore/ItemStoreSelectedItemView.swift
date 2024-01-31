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
            Rectangle()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 100)
            
            Text(localizedItemName(of: item))
            Label {
                //TODO: 할인된 가격도 표시해야함
                Text(item.price, format: .number)
                    .font(.caption)
            } icon: {
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
            }
            
            Spacer()
            
            
            HStack {
                let isWearing: Bool = itemStoreViewModel.wearingItems.contains(where: { $0 == item })
                let isInTheCart: Bool = cart.items.contains { $0 == item }
                
                Button(action: tryOn) {
                    Text(isWearing ? Localized.alreadyWearing : Localized.tryOn)
                }
                .buttonStyle(
                    FQStrokeButtonStyle(
                        disabled: isWearing,
                        hasInfinityWidth: false
                    )
                )
                .disabled(isWearing)
                
                Button(action: addToCart) {
                    Text(isInTheCart ? Localized.isInTheCart : Localized.addToCart)
                }
                .buttonStyle(
                    FQFilledButtonStyle(
                        disabled: isInTheCart,
                        hasInfinityWidth: false
                    )
                )
                .disabled(isInTheCart)
            }
            
        }
        .padding()
        .presentationDetents([.fraction(0.4)])
    }
    
    private func tryOn() {
        itemStoreViewModel.send(.tryOn(item: item, languageCode: languageCodeString))
        //TODO: 중복된 카테고리의 옷을 벗고 갈아입었다는 토스트
        dismiss()

    }
    
    private func addToCart() {
        cart.send(.addItemToCart(item: item))
        //TODO: 카트에 추가했다는 토스트
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
