//
//  CartItemList.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/30/24.
//

import SwiftUI

struct CartItemList: View {
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    @EnvironmentObject private var cart: CartModel
    
    var body: some View {
        List(cart.items) { item in
            CartItemListCell(item: item)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        cart.send(.removeItem(item))
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
        }
        .listStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding(.horizontal, -8)
    }
}

fileprivate struct CartItemListCell: View {
    @Environment(\.locale) private var locale
    private let item: FQItem
    private var languageCode: String {
        guard let alpha2 = locale.language.languageCode?.identifier(.alpha2) else {
            return "en"
        }
        
        if alpha2 != "ko" && alpha2 != "en" { return "en" }
        
        return alpha2
    }
    
    init(item: FQItem) {
        self.item = item
    }
    
    var body: some View {
        HStack {
            itemImage
            
            GeometryReader { geo in
                HStack(alignment: .top) {
                    itemTypeAndName(geo)
                    
                    itemPriceLabel(geo)
                }
            }
        }
    }
    
    private var itemImage: some View {
        Rectangle()
            .foregroundStyle(.thinMaterial)
            .frame(width: 60, height: 60)
            .overlay {
                StorageImageView(item.storageImagePath(equipped: false)) {
                    ProgressView()
                }
                .scaledToFit()
            }
    }
    
    private func itemTypeAndName(_ geo: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            Text(item.type.localizedName)
                .font(.caption2)
                .foregroundStyle(.secondary)
            
            Text(
                item.names.first(where: {
                    $0.languageCode.rawValue == languageCode
                })?.name ?? "No Data"
            )
            .font(.headline)
            .lineLimit(1)
        }
        .padding(.top, 8)
        .frame(height: geo.size.height, alignment: .top)
        .frame(maxWidth: geo.size.width * 0.65, alignment: .leading)
    }
    
    private func itemPriceLabel(_ geo: GeometryProxy) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15, height: 15)
                
                Text(item.price, format: .number)
                    .font(.system(size: 14))
                    .overlay {
                        if item.isOnEvent {
                            Line()
                                .stroke(lineWidth: 2.5)
                                .foregroundStyle(.red)
                        }
                    }
                
                if item.isOnEvent {
                    Text(item.specialPrice, format: .number)
                        .font(.system(size: 14))
                }
            }
            
            Text(item.isOnEvent ?
                 String(localized: "cartView.discounted.price" ,defaultValue: "Discounted Price") :
                    String(localized: "cartView.original.price" ,defaultValue: "Original Price")
            )
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        .frame(height: geo.size.height, alignment: .center)
        .frame(minWidth: 90, alignment: .leading)
    }
    
}

