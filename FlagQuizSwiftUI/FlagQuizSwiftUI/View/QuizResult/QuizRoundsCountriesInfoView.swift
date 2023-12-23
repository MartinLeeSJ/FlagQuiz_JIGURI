//
//  QuizRoundsCountriesInfoView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/21/23.
//

import SwiftUI

struct QuizRoundsCountriesInfoView: View {
    @EnvironmentObject private var viewModel: QuizViewModel
    private let quizRounds: [FQQuizRound]
    
    init(quizRounds: [FQQuizRound]) {
        self.quizRounds = quizRounds
    }
    
    private let rows: [GridItem] = .init(
        repeating: .init(.adaptive(minimum: 60, maximum: 80), spacing: 16),
        count: 3
    )
    
    private let columns: [GridItem] = [.init(.adaptive(minimum: 150), spacing: 4)]
 
    var body: some View {
        VStack(alignment: .leading) {
            Text("quiz.result.countries.info.title")
                .font(.title3.bold())
                .padding(.horizontal)
                .padding(.top, 16)
            
            if #available(iOS 17.0, *) {
                content
                    .scrollTargetBehavior(.paging)
            } else {
                content
            } 
        }
    }
    
    private var content: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows, spacing: 16) {
                ForEach(quizRounds, id: \.self) { round in
                    Button {
                        viewModel.send(
                            .navigate(
                                to: .countryDetail(round.answerCountryCode)
                            )
                        )
                    } label: {
                        label(round)
                    }
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
            .padding(.vertical)
        }
        .background(Material.ultraThin)
        .scrollIndicators(.never)
    }
    
    private func label(_ round: FQQuizRound) -> some View {
        HStack {
            Text(round.answerCountryCode.flagEmoji ?? "none")
                .font(.title)
          
            Text(round.answerCountryCode.localizedName ?? "none")
                .font(.caption)
                .fontWeight(.medium)
            
            Image(systemName: "chevron.right")
                .font(.caption)
        }
        .foregroundStyle(Color(uiColor: .label))
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Material.ultraThin)
        }
    }
    
}

#Preview {
    QuizRoundsCountriesInfoView(quizRounds: [
        .init(answerCountryCode: .init("170"), quizOptionsCount: 4),
        .init(answerCountryCode: .init("166"), quizOptionsCount: 4),
        .init(answerCountryCode: .init("162"), quizOptionsCount: 4),
    ])
}
