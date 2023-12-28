//
//  QuizRecordView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/28/23.
//

import SwiftUI

struct QuizRecordView: View {
    @StateObject private var viewModel: QuizRecordViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    
    init(viewModel: QuizRecordViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    QuizRecordView(
        viewModel: .init(
            container: .init(
                services: StubService()
            )
        )
    )
    .environmentObject(NavigationModel())
}
