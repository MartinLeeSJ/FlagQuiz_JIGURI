//
//  ItemStoreFrogView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreFrogView: View {
    @EnvironmentObject private var frogModel: FrogModel
    @EnvironmentObject private var itemStoreViewModel: ItemStoreViewModel
    
    var body: some View {
        FrogImageView(
            frog: frogModel.frog,
            items: itemStoreViewModel.triedOnItems,
            size: 175
        )
        .aspectRatio(1, contentMode: .fit)
        .frame(width: 175)
        .padding(25)
        .background(in: .rect(cornerRadius: 12, style: .continuous))
        .backgroundStyle(.thinMaterial)
    }
}

