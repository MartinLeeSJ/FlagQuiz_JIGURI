//
//  AllRankInfoView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/3/24.
//

import SwiftUI

struct AllRankInfoView: View {
    private let userQuizStat: FQUserQuizStat
    
    init(_ userQuizStat: FQUserQuizStat) {
        self.userQuizStat = userQuizStat
    }
    
    var body: some View {
        Text("user.rank.all.rank.info.title")
            .font(.headline)
        
        ScrollView(.horizontal) {
            LazyHStack(spacing: 16) {
                ForEach(FQUserRank.allCases, id: \.self) { rank in
                    rankInfoCard(rank)
                }
            }
            .safeAreaInset(edge: .leading) {}
            .safeAreaInset(edge: .trailing) {}
        }
        .scrollIndicators(.never)
        .padding(.horizontal, -16)
    }
    
    @ViewBuilder
    private func rankInfoCard(_ rank: FQUserRank) -> some View {
        VStack(alignment: .leading) {
            VStack {
                Group{
                    Text("Lv. \(rank.rawValue)")
                        .fontWeight(.bold)
                    Text(rank.localizedRankName)
                }
                .font(.subheadline)
                .redacted(
                    reason: userQuizStat.rank.rawValue >= rank.rawValue ? .privacy : .placeholder
                )
   
                Image(rank.medalImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .clipShape(Circle())
                    .redacted(
                        reason: userQuizStat.rank.rawValue >= rank.rawValue ? .privacy : .placeholder
                    )
                    .overlay() {
                        if userQuizStat.rank.rawValue < rank.rawValue {
                            Image(systemName: "questionmark")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                    }
            }
            .frame(maxWidth: .infinity)
            
            
            
            Spacer()
            let rankUpCriteriaDescription = rank.rankUpCriteriaDescription
            Group {
                Text("rank.info.card.quiz.count.description.\(rankUpCriteriaDescription.quizCount)")
                Text("rank.info.card.quiz.accuracy.description.\(rankUpCriteriaDescription.accuracy)")
            }
            .font(.caption)
            .lineLimit(nil)
            
        }
        .padding(16)
        .frame(width: 160)
        .frame(maxHeight: 240)
        .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        .backgroundStyle(.thinMaterial)
    }
}

