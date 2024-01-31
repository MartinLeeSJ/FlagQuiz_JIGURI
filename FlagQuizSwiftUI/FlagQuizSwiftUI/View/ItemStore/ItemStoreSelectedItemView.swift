//
//  ItemStoreSelectedItemView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreSelectedItemView: View {
    @Environment(\.locale) private var locale
    @Binding private var selectedItem: FQItem?
    @Binding private var wearingItems: [FQItem]
    @Binding private var cartSet: Set<FQItem>
    @Binding private var toast: ToastAlert?

    private let item: FQItem
    
    init(
        selectedItem: Binding<FQItem?>,
        wearingItems: Binding<[FQItem]>,
        cartSet: Binding<Set<FQItem>>,
        toast: Binding<ToastAlert?>,
        item: FQItem
    ) {
        self._selectedItem = selectedItem
        self._wearingItems = wearingItems
        self._cartSet = cartSet
        self._toast = toast
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
                let isWearing: Bool = wearingItems.contains(where: { $0 == item })
                let isInTheCart: Bool = cartSet.contains { $0 == item }
                
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
        if let index = wearingItems.firstIndex(where: { $0.type == item.type }) {
            let takingOffItem: FQItem = wearingItems.remove(at: index)
            toast = .init(
                message: Localized.changeCloth(
                    from: localizedItemName(of: takingOffItem),
                    to: localizedItemName(of: item)
                )
            )
        }
        
        wearingItems.append(item)
        selectedItem = nil
    }
    
    private func addToCart() {
        cartSet.insert(item)
        toast = .init(message: Localized.addedToCart(item: localizedItemName(of: item)))
        selectedItem = nil
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
    
    static func changeCloth(from: String, to: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.change.cloth.from.\(from).to.\(to)"
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
    
    static func addedToCart(item: String) -> String {
        String(
            localized: "itemStoreView.toastAlert.added.to.cart.\(item)"
        )
    }
}
