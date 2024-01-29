//
//  ItemStoreFrogView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/29/24.
//

import SwiftUI

struct ItemStoreFrogView: View {
    var body: some View {
        Image("frogGood")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 200)
            .padding(25)
            .background(in: .rect(cornerRadius: 12, style: .continuous))
            .backgroundStyle(.thinMaterial)
    }
}

