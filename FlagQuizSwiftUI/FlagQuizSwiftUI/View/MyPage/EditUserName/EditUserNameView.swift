//
//  EditUserNameView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/11/24.
//

import SwiftUI

struct EditUserNameView: View {
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    @EnvironmentObject private var myPageViewModel: MyPageViewModel
    @StateObject private var viewModel: EditUserNameViewModel
    
    private let user: FQUser?
    
    init(viewModel: EditUserNameViewModel, user: FQUser?) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.user = user
    }
    
    var body: some View {
        UserNameInputView(
            userName: $viewModel.userName) {
                viewModel.updateUserName(user: user) {
                    dismiss()
                    Task {
                        await myPageViewModel.load()
                    }
                }
            }
            .alert(
                isPresented: $viewModel.isAlertOn,
                error: viewModel.editUserNameError) { error in
                    
                } message: { error in
                    Text(error.failureReason ?? "")
                }
    }
}

#Preview {
    EditUserNameView(
        viewModel: .init(
            container: .init(
                services: StubService()
            )
        ), user: nil
    )
    .environmentObject(MyPageViewModel(container: .init(services: StubService())))
}
