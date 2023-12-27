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
                
                NewsGrid()
            }
        }
        .task {
            await viewModel.load()
        }
        .navigationDestination(for: NewsDestination.self) { destination in
            switch destination {
            case .countryQuizStat: 
                CountryQuizStatView(viewModel: .init(container: container))
            case .userRank:
                Text("userRank")
            case .quizStat:
                Text("quizStat")
            case .todayCountry:
                Text("todayCountry")
            }
        }
        .environmentObject(viewModel)
        
    }

}



#Preview {
    NewsView(viewModel: NewsViewModel(container: .init(services: StubService())))
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}
