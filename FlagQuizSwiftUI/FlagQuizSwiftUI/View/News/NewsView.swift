//
//  NewsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Button {
            authViewModel.send(.signOut)
        } label: {
            Text("logout")
            
        }
    }
}

#Preview {
    NewsView(viewModel: NewsViewModel(container: .init(services: StubService())))
        .environmentObject(AuthenticationViewModel(container: .init(services: StubService())))
}
