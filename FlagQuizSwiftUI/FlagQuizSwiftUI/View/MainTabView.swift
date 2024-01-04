//
//  MainTabView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

enum Tabs: Int, Hashable, CaseIterable {
    case quizSetting = 0
    case news
    
    var title: LocalizedStringKey {
        switch self {
        case .quizSetting: "tabs.quizSetting.title"
        case .news: "tabs.news.title"
        }
    }
    
    var imageName: String {
        switch self {
        case .quizSetting: "q.square.fill"
        case .news: "newspaper.fill"
        }
    }
}

struct MainTabView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @State private var tabSelection: Tabs = .quizSetting
    
    var body: some View {
//        NavigationStack(path: $navigationModel.destinations) {
            TabView(selection: $tabSelection) {
                content
            }
//        }
    }
    
    @ViewBuilder
    var content: some View {
        ForEach(Tabs.allCases, id: \.self) { tab in
            Group {
                switch tab {
                case .quizSetting:
                    QuizSettingView(viewModel: .init(container: container))
                    
                case .news:
                    NewsView(viewModel: .init(container: container))
                }
            }
            .tabItem {
                VStack {
                    Text(tab.title)
                    Image(systemName: tab.imageName)
                }
            }
            
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(DIContainer(services: StubService()))
        .environmentObject(NavigationModel())
}
