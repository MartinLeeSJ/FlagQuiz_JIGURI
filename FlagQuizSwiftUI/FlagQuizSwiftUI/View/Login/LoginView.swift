//
//  LoginView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    var body: some View {
        ZStack {
            Color.accentColor
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Image("frogHeadBig")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                Text("loginView.title")
                    .font(.custom(FontName.pixel, size: 45))
                    .foregroundStyle(.black)
                
                Spacer()
                
                Text(
                    String(
                        localized:"loginView.login.condition",
                        defaultValue: "Do you have a account or want to start with sign in?"
                    )
                )
                .multilineTextAlignment(.center)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundStyle(.black)
                
                SignInWithAppleButton(.continue) { request in
                    authViewModel.send(.requestSignInWithApple(request))
                } onCompletion: { result in
                    if case .success(let authorization) = result {
                        authViewModel.send(.completeSignInWithApple(authorization))
                    }
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 45)
                
                Divider()
                    .overlay {
                        Text(
                            String(
                                localized: "loginView.or",
                                defaultValue:"OR"
                            )
                        )
                        .foregroundStyle(.black)
                        .fontWeight(.bold)
                        .padding(2)
                        .background(.fqAccent)
                    }
                    .padding()
                
                Button {
                    authViewModel.send(.anonymousSignIn)
                } label: {
                    Text(
                        String(
                            localized: "loginView.anonymous.login.title",
                            defaultValue: "Start Without Sign In"
                        )
                    )
                    .font(.headline)
                }
                .buttonStyle(QuizFilledButtonStyle(disabled: false, isLightModeOnly: true))

            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
