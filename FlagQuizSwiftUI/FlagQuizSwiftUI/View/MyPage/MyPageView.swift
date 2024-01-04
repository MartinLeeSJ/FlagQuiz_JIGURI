//
//  MyPageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    var body: some View {
        Button {
            authViewModel.send(.signOut)
        } label: {
            Text("LogOut")
                .font(.headline)
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(
            AuthenticationViewModel(
                container: .init(
                    services: StubService()
                )
            )
        )
}
