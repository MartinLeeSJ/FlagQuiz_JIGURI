//
//  EditUserNameView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/11/24.
//

import SwiftUI

struct EditUserNameView: View {
    @State private var userName: String = ""
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            TextField(text: $userName) {
                Text("editUserName.textField.title")
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
                Text("editUserName.length.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            HStack {
                validationSymbol(
                    condition: isEnglishAndNumbersOnly(userName)
                )
                Text("editUserName.length.instruction")
            }
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 16)
                
            Button{
                
            } label: {
                Text("editUserName.submitButton.title")
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
        let allowedCharacterSet = CharacterSet.alphanumerics
        let inputCharacterSet = CharacterSet(charactersIn: input)
        
        return inputCharacterSet.isSubset(of: allowedCharacterSet)
    }
    
    
}

#Preview {
    EditUserNameView()
}
