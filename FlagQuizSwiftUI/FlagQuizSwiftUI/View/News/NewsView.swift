//
//  NewsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer()
                    .frame(height: 100)
                ZStack {
                    Image("Frog")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 200)
                }
                
                newsGrid
            }
        }
        .navigationTitle(Tabs.news.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.load()
        }
        .navigationDestination(for: NewsDestination.self) { destination in
            switch destination {
            case .countryQuizStat: Text("CountryQuizStat")
            case .userRank:
                Text("userRank")
            case .quizStat:
                Text("quizStat")
            case .todayCountry:
                Text("todayCountry")
            }
            
        }
        
    }
    
    private var newsGrid: some View {
        Grid(horizontalSpacing: 8, verticalSpacing: 8) {
            GridRow {
                userRankCell
                
                countryQuizStatCell
                
                quizStatCell
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
                todayCountryCell
            }
            .frame(maxHeight: 110)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding()
    }
    
    
    private var userRankCell: some View {
        let rank: FQUserRank? = viewModel.quizStat?.rank
        return NewsGridCell(
            title: "news.user.rank.title"
        ) {
            Image(rank?.medalImageName ?? "MedalNewbie")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(minHeight: 30, maxHeight: 45)
                .overlay(alignment: .bottom) {
                    Text(rank?.localizedRankName ?? "-")
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundStyle(Color(uiColor: .label))
                        .offset(y: 16)
                }
        }
        .gridCellColumns(1)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.userRank)
        }
    }
    
    private var countryQuizStatCell: some View {
        NewsGridCell(
            title: "news.country.quiz.stats.title"
        ) {
            let countryCode: FQCountryISOCode? = viewModel.countryQuizStat?.id
            
            Text(countryCode?.flagEmoji ?? "?")
                .font(.largeTitle)
                .foregroundStyle(Color(uiColor: .label))
                .frame(maxWidth: .infinity)
                .overlay(alignment: .bottom) {
                    Text(countryCode?.localizedName ?? "-")
                        .lineLimit(1)
                        .font(.caption2)
                        .foregroundStyle(Color(uiColor: .label))
                        .offset(y: 16)
                }
            
        }
        .gridCellColumns(2)
        .onTapGesture {
            navigationModel.navigate(to: NewsDestination.countryQuizStat)
        }
    }
    
    private var quizStatCell: some View {
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
            navigationModel.navigate(to: NewsDestination.quizStat)
        }
    }
    
    private var todayCountryCell: some View {
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



#Preview {
    NewsView(viewModel: NewsViewModel(container: .init(services: StubService())))
        .environmentObject(AuthenticationViewModel(container: .init(services: StubService())))
        .environmentObject(NavigationModel())
}
