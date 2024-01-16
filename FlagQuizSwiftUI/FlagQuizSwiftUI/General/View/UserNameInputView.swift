//
//  UserNameInputView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/15/24.
//

import SwiftUI

struct UserNameInputView: View {
    @Binding private var userName: String
    @FocusState private var isFocused
    private let action: () -> Void
    
    init(
        userName: Binding<String>,
        action: @escaping () -> Void
    ) {
        self._userName = userName
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 16) {
            TextField(text: $userName) {
                Text("userNameInput.textField.title")
            }
            .padding()
            .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            .backgroundStyle(.thinMaterial)
            .focused($isFocused)
            .onAppear { isFocused = true }
           
             
            HStack {
                validationSymbol(
                    condition: isLengthUnderTwentyOverZero(userName)
                )
                Text("userNameInput.length.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            HStack {
                validationSymbol(
                    condition: isEnglishAndNumbersOnly(userName)
                )
                Text("userNameInput.character.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
                
            Button{
                action()
            } label: {
                Text("userNameInput.submitButton.title")
            }
            .disabled(!isValidUserName(userName))
        }
        .padding()
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
    UserNameInputView(userName: .constant("seokjunlee")) {}
}
