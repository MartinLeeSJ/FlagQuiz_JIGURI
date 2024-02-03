//
//  ClosetFrogView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/1/24.
//

import SwiftUI

struct ClosetFrogView: View {
    @EnvironmentObject private var closetViewModel: ClosetViewModel
    @EnvironmentObject private var frogModel: FrogModel

    
    var body: some View {
        FrogImageView(
            frog: frogModel.frog,
            items: $closetViewModel.currentEquippedItems,
            size: 200
        )
        .padding(25)
        .background(in: .rect(cornerRadius: 12, style: .continuous))
        .backgroundStyle(.thinMaterial)
    }
}

