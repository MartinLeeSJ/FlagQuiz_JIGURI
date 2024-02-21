//
//  QuizStatCell.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/27/23.
//

import SwiftUI

struct QuizStatCell: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var viewModel: NewsViewModel
    
    var body: some View {
        NewsGridCell(
            title: "news.quiz.stats.title"
        ) {
            VStack(spacing: 4) {
                Text("\(viewModel.quizStat?.totalCorrectQuizCount ?? 0) / \(viewModel.quizStat?.totalQuizCount ?? 0)")
                    .font(.subheadline)
                    .foregroundStyle(Color(uiColor: .label))
            }
        }
        .gridCellColumns(1)
        .onTapGesture {
            guard let isAnonymousUser = viewModel.isAnonymousUser() else {
                 return
            }
            
            if isAnonymousUser {
                viewModel.setLinkingLocation(.userStat)
            } else {
                container.navigationModel.navigate(to: NewsDestination.quizRecord)
            }
        }
    }
}

