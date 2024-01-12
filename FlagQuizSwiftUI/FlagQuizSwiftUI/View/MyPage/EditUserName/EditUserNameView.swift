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
        VStack(spacing: 16) {
            TextField(text: $viewModel.userName) {
                Text("editUserName.textField.title")
            }
            .padding()
            .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .backgroundStyle(.thinMaterial)
            .focused($isFocused)
            .onAppear { isFocused = true }
           
             
            HStack {
                validationSymbol(
                    condition: isLengthUnderTwentyOverZero(viewModel.userName)
                )
                Text("editUserName.length.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            HStack {
                validationSymbol(
                    condition: isEnglishAndNumbersOnly(viewModel.userName)
                )
                Text("editUserName.character.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
                
            Button{
                viewModel.updateUserName(user: user) {
                    dismiss()
                    Task {
                        await myPageViewModel.load()
                    }
                }
            } label: {
                Text("editUserName.submitButton.title")
            }
            .disabled(!isValidUserName(viewModel.userName))
        }
        .padding()
        .alert(
            isPresented: $viewModel.isAlertOn,
            error: viewModel.editUserNameError) { error in
                
            } message: { error in
                Text(error.failureReason ?? "")
            }

        
    }
    
    @ViewBuilder
    private func validationSymbol(condition isValid: Bool) -> some View {
        if isValid {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.green)
        } else {
            Image(systemName: "xmark.circle")
                .foregroundStyle(.foreground)
        }
    }
    
    
    private func isValidUserName(_ input: String) -> Bool {
         isLengthUnderTwentyOverZero(input) && isEnglishAndNumbersOnly(input)
    }
    
    private func isLengthUnderTwentyOverZero(_ input: String) -> Bool {
        (!input.isEmpty) && (input.count <= 20)
    }
    
    private func isEnglishAndNumbersOnly(_ input: String) -> Bool {
        guard !input.isEmpty else { return false }
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let inputCharacterSet = CharacterSet(charactersIn: input)
        
        return inputCharacterSet.isSubset(of: allowedCharacterSet)
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
