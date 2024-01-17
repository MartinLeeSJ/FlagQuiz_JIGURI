//
//  NewsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var notificationManager: NotificationManager
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
                    FrogView(
                        viewModel: .init(
                            container: container,
                            notificationManager: notificationManager
                        )
                    )
                    
                    NewsGrid()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EarthCandyView()
                }
                
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
                        MyPageView(viewModel: .init(container: container))
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
        let container = DIContainer(services: StubService())
        NewsView(viewModel: NewsViewModel(container: container))
            .environmentObject(container)
            .environmentObject(NavigationModel())
            .environmentObject(NotificationManager())
            .environmentObject(AuthenticationViewModel(container: container))
    }
}
