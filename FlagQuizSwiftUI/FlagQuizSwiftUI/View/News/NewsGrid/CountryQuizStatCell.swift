//
//  CountryQuizStatCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct CountryQuizStatCell: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        NewsGridCell(
            title: "news.country.quiz.stats.title"
        ) {
            let countryCode: FQCountryISOCode? = viewModel.countryQuizStat?.id
            
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
        .gridCellColumns(2)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.countryQuizStat)
        }
    }
}
