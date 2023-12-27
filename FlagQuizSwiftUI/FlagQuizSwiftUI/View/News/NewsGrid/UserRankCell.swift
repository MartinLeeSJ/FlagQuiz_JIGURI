//
//  UserRankCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct UserRankCell: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        let rank: FQUserRank? = viewModel.quizStat?.rank
        return NewsGridCell(
            title: "news.user.rank.title"
        ) {
            Image(rank?.medalImageName ?? "MedalNewbie")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 30, maxHeight: 45)
                .overlay(alignment: .bottom) {
                    Text(rank?.localizedRankName ?? "-")
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundStyle(Color(uiColor: .label))
                        .offset(y: 16)
                }
        }
        .gridCellColumns(1)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.userRank)
        }
    }
}

