//
//  NewsGrid.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct NewsGrid: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    

    var body: some View {
        GeometryReader { geo in
            Grid(horizontalSpacing: 8, verticalSpacing: 8) {
                GridRow {
                    BannerAdContentView()
                        .padding(6)
                        .background(.thinMaterial, in: Rectangle())
                        .gridCellColumns(2)
                }
                .frame(height: 70)
                
                GridRow {
                    UserRankCell()
                    
                    BestCountryQuizStatCell()
                }
                .frame(height: 110)
                
                GridRow {
                    QuizStatCell()
                    
                    WorstCountryQuizStatCell()
                }
                .frame(height: 110)
                
                GridRow {
                    TodayCountryCell()
                }
                .frame(height: 110)
            }
            .padding()
            .frame(width: geo.size.width)
        }
        .frame(minHeight: 400, maxHeight: 500)
    
    }
}

#Preview {
    NewsGrid()
        .environmentObject(NewsViewModel(container: .init(services: StubService())))
        
}
