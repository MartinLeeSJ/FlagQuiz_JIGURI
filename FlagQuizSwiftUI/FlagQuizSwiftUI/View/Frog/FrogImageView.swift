//
//  FrogImageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import SwiftUI

struct FrogImageView<Item>: View where Item: FQItemProtocol {
    private var items: [Item]
    private let frog: FQFrog?
    private let size: CGFloat
    
    init(
        frog: FQFrog?,
        items: [Item],
        size: CGFloat
    ) {
        self.frog = frog
        self.items = items
        self.size = size
    }
    
    private var allItemTypeExceptBackground: [FQItemType] {
        Array(FQItemType.allCases[1...])
    }
    
    var body: some View {
        ZStack {
            if let background = items.first(where: { $0.type == .background }) {
                itemImage(background)
            }
            
            Image(frog?.state.frogImageName ?? "frogSoSo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: size)
            
            ForEach(allItemTypeExceptBackground, id: \.self) { itemType in
                let item = items.first(where: { $0.type == itemType })
                
                itemImage(item)
                    .id(item?.id)
            }
            
           
        }
    }
    
    @ViewBuilder
    private func itemImage(_ item: FQItemProtocol?) -> some View {
        if let item {
            StorageImageView(item.storageImagePath(equipped: true)) {
                ProgressView()
                    .foregroundStyle(.clear)
                    .frame(width: size, height: size)
            }
            .scaledToFit()
            .frame(maxWidth: size)
        }
    }
}
