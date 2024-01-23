//
//  LinkingLoginView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/23/24.
//

import SwiftUI
import AuthenticationServices

struct LinkingLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var navigationModel: NavigationModel
    @StateObject private var viewModel: LinkingLoginViewModel
    
    private let location: LinkingLoginLocation?
    
    init(
        viewModel: LinkingLoginViewModel,
        location: LinkingLoginLocation?
    ) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.location = location
    }
    var body: some View {
        VStack {
            Spacer()
            Image("frogHeadBig")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
            Image("LetterBoxBig")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 340)
                .overlay {
                    Text(location?.description ?? "")
                        .multilineTextAlignment(.center)
                        .font(.custom(FontName.pixel, size: 20))
                        .foregroundStyle(.black)
                        .lineSpacing(10.0)
                        .offset(y: 10)
                }
            
            Spacer()
            
            SignInWithAppleButton(.continue) { request in
                viewModel.send(.requestSignInWithApple(request))
            } onCompletion: { result in
                switch result {
                case.success(let authorization):
                    viewModel.send(.completeSignInWithApple(authorization))
                case .failure:
                    viewModel.toast = .init(
                        style: .failed,
                        message: String(
                            localized: "toastAlert.linkingLogin.failed",
                            defaultValue: "Failed to create an account"
                        )
                    )
                }
            }
            .signInWithAppleButtonStyle(.whiteOutline)
            .frame(height: 45)
        }
        .padding()
        .background(.fqAccent)
        .background(ignoresSafeAreaEdges: .all)
        .toastAlert($viewModel.toast)
        .onChange(of: viewModel.linkingState, perform: { value in
            if value == .linked {
                dismiss()
            }
        })
        .alert(
            "linkingLoginView.should.signOut.alert.title",
            isPresented: $viewModel.presentsShouldLogOutAlert) {
                Button {
                    navigationModel.toRoot()
                    authViewModel.send(.signOut)
                } label: {
                    Text("OK")
                }
            } message: {
                Text(
                    String(
                        localized: "linkingLoginView.should.signOut.alert.message",
                        defaultValue: "You already have an account. Please Sign In"
                    )
                )
            }

        
    }
}




