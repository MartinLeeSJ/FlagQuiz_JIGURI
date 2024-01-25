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
        GeometryReader { geo in
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                GridRow {
                    UserRankCell()
                    
                    CountryQuizStatCell()
                    
                    QuizStatCell()
                }
                .frame(height: 110)
                
                GridRow {
                    BannerAdContentView()
                        .padding(6)
                        .background(.thinMaterial, in: Rectangle())
                        .gridCellColumns(4)
                }
                .frame(height: 70)
                
                GridRow {
                    TodayCountryCell()
                }
                .frame(height: 110)
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding()
            .frame(width: geo.size.width)
        }
        .frame(minHeight: 300, maxHeight: 400)
    
    }
}

#Preview {
    NewsGrid()
        .environmentObject(NewsViewModel(container: .init(services: StubService())))
        .environmentObject(NavigationModel())
}
