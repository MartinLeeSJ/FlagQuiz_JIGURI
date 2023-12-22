//
//  NewsView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import SwiftUI

struct NewsView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    var body: some View {
        Button {
            authViewModel.send(.signOut)
        } label: {
            Text("logout")
            
        }
    }
}

#Preview {
    NewsView()
}
