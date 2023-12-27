//
//  NewsGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct NewsGrid: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    

    var body: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                UserRankCell()
                
                CountryQuizStatCell()
                
                QuizStatCell()
            }
            .frame(maxHeight: 140)
            
            GridRow {
                NewsGridCell(
                    alignment: .leading,
                    title: "advertisement"
                ) {
                    Text("광고")
                }
                .gridCellColumns(4)
            }
            .frame(maxHeight: 120)
            
            GridRow {
                TodayCountryCell()
            }
            .frame(maxHeight: 110)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
}

