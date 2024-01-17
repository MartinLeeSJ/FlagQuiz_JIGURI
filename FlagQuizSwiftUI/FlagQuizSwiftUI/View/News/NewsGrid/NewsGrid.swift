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
                BannerAdContentView()
                    .padding(6)
                    .background(.thinMaterial, in: Rectangle())
                    .gridCellColumns(4)
                    .frame(minHeight: 62, alignment: .center)
            }
            
            GridRow {
                TodayCountryCell()
            }
            .frame(maxHeight: 110)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding()
    }
}

