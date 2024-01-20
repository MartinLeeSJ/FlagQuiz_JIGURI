//
//  FrogSettlementIcon.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/20/24.
//

import SwiftUI

struct FrogSettlementIcon: View {
    private let frog: FQFrog?
    
    init(frog: FQFrog?) {
        self.frog = frog
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 42)

            VStack(spacing: 2) {
                if let frogNation = frog?.nation,
                   let flagEmoji = frogNation.flagEmoji,
                   let localizedName = frogNation.localizedName {
                    Text(
                        String(
                            localized: "frogSettlementIcon.title",
                            defaultValue: "Frog Settelment"
                        )
                    )
                        .font(.caption2)
                    Text(flagEmoji)
                        .font(.system(size: 30))
                    Text(localizedName)
                        .font(.caption2)
                        .frame(height: 12)
                } else {
                    Text(
                        String(
                            localized: "frogSettlementIcon.title",
                            defaultValue: "Frog Settelment"
                        )
                    )
                    .font(.caption2)
                    Image(systemName: "questionmark")
                        .font(.system(size: 20))
                    
                    Text(
                        String(
                            localized: "frogSettlementIcon.loading.description",
                            defaultValue: "Not Determined"
                        )
                    )
                    .font(.caption2)
                    .frame(height: 12)
                    
                }
            }
            .padding(.horizontal)
            .frame(width: 100)
            .background(in: .circle)
            .backgroundStyle(.thinMaterial)
        }
    }
}

