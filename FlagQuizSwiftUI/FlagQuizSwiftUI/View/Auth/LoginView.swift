//
//  LoginView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    var body: some View {
        VStack {
            Button {
                
            } label: {
                Text("구글로 로그인 하기")
                
            }
            .buttonStyle(.bordered)
            .buttonBorderShape(.roundedRectangle(radius: 10))
            
            SignInWithAppleButton { _ in
                
            } onCompletion: { _ in
                
            }
            .frame(height: 45)

        }
        .padding()
    }
}

#Preview {
    LoginView()
}
