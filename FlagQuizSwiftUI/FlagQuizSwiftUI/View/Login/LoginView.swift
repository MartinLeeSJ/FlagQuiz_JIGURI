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
                Image("AppIconWoBg")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                
                Spacer()
                
                // 현재는 애플로그인시 이메일을 안불러옴
                /*
                Button {
                    authViewModel.send(.signInWithGoogle)
                } label: {
                    Text("sign.in.with.google")
                        .font(.system(size: 14))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(.white,
                                    in: RoundedRectangle(cornerRadius: 8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black ,lineWidth: 1)
                        }
                }
                 */
                
                SignInWithAppleButton(.continue) { request in
                    authViewModel.send(.requestSignInWithApple(request))
                } onCompletion: { result in
                    if case .success(let authorization) = result {
                        authViewModel.send(.completeSignInWithApple(authorization))
                    }
                }
                .signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 45)

            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}
