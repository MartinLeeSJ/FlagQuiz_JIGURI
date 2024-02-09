//
//  WorstCountryQuizStatCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/9/24.
//

import SwiftUI

struct WorstCountryQuizStatCell: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        NewsGridCell(
            title: "news.worst.country.quiz.stats.title"
        ) {
            let countryCode: FQCountryISOCode? = viewModel.worstCountryQuizStat?.id
            
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
                navigationModel.navigate(to: NewsDestination.countryQuizStat)
            }
        }
    }
}

#Preview {
    WorstCountryQuizStatCell()
}
