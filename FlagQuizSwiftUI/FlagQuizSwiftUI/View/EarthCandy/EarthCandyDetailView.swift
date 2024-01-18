//
//  EarthCandyDetailView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import SwiftUI

struct EarthCandyDetailView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack {
            Button("dismiss") {
                dismiss()
            }
            
            RewardedAdButton { reward in
                print(reward)
            } buttonLabel: {
                Text("광고 테스트")
            }

        }
    }
}

#Preview {
    EarthCandyDetailView()
}
