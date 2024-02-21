//
//  BestCountryQuizStatCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct BestCountryQuizStatCell: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: NewsViewModel
    
    var body: some View {
        NewsGridCell(
            title: "news.country.quiz.stats.title"
        ) {
            let countryCode: FQCountryISOCode? = viewModel.bestCountryQuizStat?.id
            
            Text(countryCode?.flagEmoji ?? "?")
                .font(.largeTitle)
                .foregroundStyle(Color(uiColor: .label))
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    Text(countryCode?.localizedName ?? "-")
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundStyle(Color(uiColor: .label))
                        .offset(y: 16)
                }
            
        }
        .gridCellColumns(1)
        .onTapGesture {
            guard let isAnonymousUser = viewModel.isAnonymousUser() else {
                 return
            }
            
            if isAnonymousUser {
                viewModel.setLinkingLocation(.countryStat)
            } else {
                container.navigationModel.navigate(to: NewsDestination.countryQuizStat)
            }
        }
    }
}
