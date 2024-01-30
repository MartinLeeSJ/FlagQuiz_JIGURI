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
    @StateObject private var frogModel: FrogModel
    
    init(
        viewModel: NewsViewModel,
        frogModel: FrogModel
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._frogModel = StateObject(wrappedValue: frogModel)
    }
    
    var body: some View {
        NavigationStack(path: $navigationModel.destinations) {
            ScrollView {
                VStack {
                    FrogView()
                        .environmentObject(frogModel)
                    
                    NewsGrid()
                    
                    Spacer()
                        .frame(height: 32)
                }
            }
            .sheet(item: $viewModel.linkingLocation) {
                LinkingLoginView(
                    viewModel: .init(container: container),
                    location: $0
                )
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EarthCandyView()
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        navigationModel.navigate(to: NewsDestination.myPage)
                    } label: {
                        Text("My")
                            .font(.custom(FontName.pixel, size: 24))
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


//
//#Preview {
//    
//    NavigationStack {
//        
//        NewsView(
//            viewModel: NewsViewModel(container: DIContainer(services: StubService()))
//        )
//            .environmentObject(DIContainer(services: StubService()))
//            .environmentObject(NavigationModel())
//            .environmentObject(NotificationManager())
//            .environmentObject(
//                AuthenticationViewModel(
//                    container: DIContainer(
//                        services: StubService()
//                    )
//                )
//            )
//    }
//}
