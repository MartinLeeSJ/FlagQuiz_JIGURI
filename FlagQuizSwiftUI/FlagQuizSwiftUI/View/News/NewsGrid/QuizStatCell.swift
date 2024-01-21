//
//  QuizStatCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct QuizStatCell: View {
    @EnvironmentObject private var viewModel: NewsViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    var body: some View {
        NewsGridCell(
            title: "news.quiz.stats.title"
        ) {
            VStack(spacing: 4) {
                Text("\(viewModel.quizStat?.correctCountryQuizCount ?? 0)")
                    .font(.subheadline)
                
                Divider()
                    .frame(width: 50)
                
                Text("\(viewModel.quizStat?.countryQuizCount ?? 0)")
                    .font(.subheadline)
            }
            .foregroundStyle(Color(uiColor: .label))
        }
        .gridCellColumns(1)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.quizRecord)
        }
    }
}

