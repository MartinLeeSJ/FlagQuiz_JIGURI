//
//  UserRankView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/1/24.
//

import SwiftUI

struct UserRankView: View {
    @StateObject private var viewModel: UserRankViewModel
    
    init(viewModel: UserRankViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel) 
    }
    

    
    var body: some View {
        if let userQuizStat = viewModel.userQuizStat {
            content(userQuizStat)
        } else {
            content(.mock)
                .redacted(reason: .placeholder)
                .task {
                    await viewModel.loadUserQuizStat()
                }
        }
    }
    
    private func content(_ userQuizStat: FQUserQuizStat) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                userRankMedal(userQuizStat)
                totalQuizRankProgress(userQuizStat)
                quizAccuracyGauges(userQuizStat)
                
                AllRankInfoView(userQuizStat)
            }
            .padding(.horizontal)
        }
       
    }
    
    @ViewBuilder
    private func userRankMedal(_ userQuizStat: FQUserQuizStat) -> some View {
        Group {
            Image(userQuizStat.rank.medalImageName)
            Text(userQuizStat.rank.localizedRankName)
                .font(.title3.bold())
        }
        .frame(maxWidth: .infinity)
        
    }
    
    @ViewBuilder
    private func totalQuizRankProgress(_ userQuizStat: FQUserQuizStat) -> some View {
        Text("total.quiz.rank.progress.title")
            .font(.headline)
        HStack(spacing: 16) {
            let rank = userQuizStat.rank
     
            VStack(alignment: .leading) {
                Text("user.rank.view.quiz.count.progress.title")
                    .font(.subheadline)
                UserRankProgressView(
                    min: Double(rank.rankUpQuizCountCriteria.min),
                    minValueText: "\(rank.rankUpQuizCountCriteria.min)",
                    max: Double(rank.rankUpQuizCountCriteria.max),
                    maxValueText: "\(rank.rankUpQuizCountCriteria.max)",
                    currentValue: Double(userQuizStat.countryQuizCount),
                    currentValueText: "\(userQuizStat.countryQuizCount)"
                )
            }
            
            VStack(alignment: .leading) {
                Text("user.rank.view.quiz.accuracy.progress.title")
                    .font(.subheadline)
                UserRankProgressView(
                    min: rank.rankUpAccuracyCriteria.min,
                    minValueText: String(format: "%.1f", rank.rankUpAccuracyCriteria.min * 100) + "%",
                    max: rank.rankUpAccuracyCriteria.max,
                    maxValueText:String(format: "%.1f", rank.rankUpAccuracyCriteria.max * 100) + "%",
                    currentValue: userQuizStat.totalAccuracy,
                    currentValueText: String(format: "%.1f", userQuizStat.totalAccuracy * 100) + "%"
                )
            }
        
        }
            .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private func quizAccuracyGauges(_ userQuizStat: FQUserQuizStat) -> some View {
        Text("user.rank.quiz.accuracy.gauges.title")
            .font(.headline)
            
        HStack {
            UserRankAccuracyGauge(
                quizCount: userQuizStat.capitalQuizCount,
                correctQuizCount: userQuizStat.correctCapitalQuizCount,
                accuracy: userQuizStat.capitalQuizAccuracy) {
                    Text("user.rank.capital.quiz.accuracy.title")
                        .font(.caption)
                }
            
            Spacer()
            
            UserRankAccuracyGauge(
                quizCount: userQuizStat.flagToNameQuizCount,
                correctQuizCount: userQuizStat.correctFlagToNameQuizCount,
                accuracy: userQuizStat.flagToNameQuizAccuracy) {
                    Text("user.rank.flag.to.name.quiz.accuracy.title")
                        .font(.caption)
                }
            
            Spacer()
            
            UserRankAccuracyGauge(
                quizCount: userQuizStat.nameToFlagQuizCount,
                correctQuizCount: userQuizStat.correctNameToFlagQuizCount,
                accuracy: userQuizStat.nameToFlagQuizAccuracy) {
                    Text("user.rank.name.to.flag.quiz.accuracy.title")
                        .font(.caption)
                }
            
        }
        .frame(height: 80)
        .padding([.horizontal, .bottom], 16)
        
    }
    
    
}

#Preview {
    UserRankView(
        viewModel: .init(
            container: .init(
                services: StubService()
            )
        )
    )
}
