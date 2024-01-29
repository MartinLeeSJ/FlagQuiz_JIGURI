//
//  StoreItemCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct StoreItemCell: View {
    @Binding private var selectedItem: FQItem?
    private let item: FQItem
    private let localizedItemName: String
    
    init(
        selectedItem: Binding<FQItem?>,
        item: FQItem,
        localizedItemName: String
    ) {
        self._selectedItem = selectedItem
        self.item = item
        self.localizedItemName = localizedItemName
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.purple)
                .aspectRatio(1, contentMode: .fit)
            
            FlowingText(localizedItemName)
                .font(.caption)
                .frame(height: 30)
               
            Label {
                Text(item.price, format: .number)
                    .font(.caption)
            } icon: {
                Image("EarthCandy")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
            }
        }
        .onTapGesture {
            selectedItem = item
        }
    }
}

