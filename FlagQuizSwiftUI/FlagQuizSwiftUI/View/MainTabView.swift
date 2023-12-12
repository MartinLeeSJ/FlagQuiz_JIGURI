//
//  MainTabView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack {
            Text("MainTab")
            Button("로그아웃") {
                authViewModel.send(.signOut)
            }
        }
    }
}

#Preview {
    MainTabView()
}
