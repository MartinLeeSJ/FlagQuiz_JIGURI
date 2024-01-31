//
//  StoreItemCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct StoreItemCell: View {
    @Environment(\.locale) private var locale
    
    private let item: FQItem
    private var localizedItemName: String {
        guard let alpha2Code = locale.language.languageCode?.identifier(.alpha2) else {
            return "No Data"
        }
        
        return item.names.first(where: {$0.languageCode.rawValue == alpha2Code})?.name ?? "No Data"
    }
    
    
    init(item: FQItem) {
        self.item = item
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundStyle(.thinMaterial)
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
        
    }
}

