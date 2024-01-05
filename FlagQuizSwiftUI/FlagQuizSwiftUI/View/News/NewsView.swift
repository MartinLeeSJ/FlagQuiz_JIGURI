//
//  NewsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.destinations) {
            ScrollView {
                VStack {
                    Spacer()
                        .frame(height: 50)
                    ZStack {
                        Image("Frog")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200)
                    }
                    
                    NewsGrid()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EarthCandyView(viewModel: .init(container: container))
                }
                
//                ToolbarItem(placement: .topBarLeading) {
//                    Rectangle()
//                        .frame(maxWidth: .infinity)
//                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationModel.navigate(to: NewsDestination.myPage)
                    } label: {
                        Circle()
                            .foregroundStyle(.green)
                            .frame(width: 30, height: 30)
                        
                    }
                    
                }
                
            }
            .task {
                await viewModel.load()
            }
            .navigationDestination(for: NewsDestination.self) { destination in
                Group {
                    switch destination {
                    case .countryQuizStat:
                        CountryQuizStatView(viewModel: .init(container: container))
                    case .userRank:
                        UserRankView(viewModel: .init(container: container))
                    case .myPage:
                        MyPageView()
                            .environmentObject(authViewModel)
                    case .quizRecord:
                        QuizRecordView(viewModel: .init(container: container))
                    case .quizRecordDetail(let record):
                        QuizRecordDetailView(record: record)
                    case .countryDetail(let countryCode):
                        CountryDetailView(
                            viewModel: .init(
                                container: container,
                                countryCode: countryCode
                            )
                        )
                    }
                }
                .toolbar(.hidden, for: .tabBar)
                
            }
            .environmentObject(viewModel)
        }
    }

}



#Preview {
    NavigationStack {
        NewsView(viewModel: NewsViewModel(container: .init(services: StubService())))
            .environmentObject(DIContainer(services: StubService()))
            .environmentObject(NavigationModel())
    }
}
