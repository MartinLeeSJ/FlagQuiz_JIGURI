//
//  TodayCountryCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct TodayCountryCell: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        NewsGridCell(
            alignment: .leading,
            title: "news.today.country.title"
        ) {
            HStack(spacing: 32) {
                let todaysCode: FQCountryISOCode? = FQCountryISOCode.todaysCode()
                Text(todaysCode?.flagEmoji ?? "?")
                    .font(.largeTitle)
                
                Text(todaysCode?.localizedName ?? "?")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(Color(uiColor: .label))
                Spacer()
                
            }
        }
        .gridCellColumns(4)
        .gridCellUnsizedAxes(.horizontal)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.todayCountry)
        }
    }
}

