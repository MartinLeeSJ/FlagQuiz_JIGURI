//
//  FrogImageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import SwiftUI

struct FrogImageView<Item>: View where Item: FQItemProtocol {
    @Binding private var items: [Item]
    
    private let frog: FQFrog?
    private let size: CGFloat
    
    init(
        frog: FQFrog?,
        items: Binding<[Item]>,
        size: CGFloat
    ) {
        self.frog = frog
        self._items = items
        self.size = size
    }
    
    var body: some View {
        ZStack {
            itemImage(ofType: .background)
            
            Image(frog?.state.frogImageName ?? "frogSoSo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: size)
            
            itemImage(ofType: .shoes)
            
            itemImage(ofType: .bottom)
            
            itemImage(ofType: .gloves)
            
            itemImage(ofType: .top)
            
            itemImage(ofType: .overall)
            
            itemImage(ofType: .faceDeco)
            
            itemImage(ofType: .accessory)
            
            itemImage(ofType: .hair)
            
            itemImage(ofType: .hat)
            
            itemImage(ofType: .set)
        }
    }
    
    @ViewBuilder
    func itemImage(ofType type: FQItemType) -> some View {
        if let item = items.first(where: { $0.type == type }) {
            StorageImageView(item.storageImagePath(true)) {
                
            }
            .scaledToFit()
            .frame(maxWidth: size)
        }
    }
}
