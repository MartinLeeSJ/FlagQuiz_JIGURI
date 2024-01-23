//
//  LinkingLoginView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/23/24.
//

import SwiftUI
import AuthenticationServices

fileprivate struct LinkingLoginView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: LinkingLoginViewModel
    
    init(viewModel: LinkingLoginViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
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
                    Text(viewModel.location.description)
                        .multilineTextAlignment(.center)
                        .font(.custom(FontName.pixel, size: 20))
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
        
    }
}

fileprivate struct LinkingLogin: ViewModifier {
    @Binding var isPresented: Bool
    private let container: DIContainer
    private let location: LinkingLoginLocation
    
    init(
        isPresented: Binding<Bool>,
        container: DIContainer,
        location: LinkingLoginLocation
    ) {
        self._isPresented = isPresented
        self.container = container
        self.location = location
    }

    
    func body(content: Content) -> some View {
        content
            .sheet(isPresented: $isPresented) {
                LinkingLoginView(
                    viewModel: .init(
                        container: container,
                        location: location
                    )
                )
            }
    }
}

extension View {
    func linkingLogin( isPresented: Binding<Bool>,
                       container: DIContainer,
                       location: LinkingLoginLocation ) -> some View {
        self.modifier(
                LinkingLogin(
                    isPresented: isPresented,
                    container: container,
                    location: location
                )
            )
    }
}


#Preview {
    LinkingLoginView(
        viewModel: .init(
            container: .init(services: StubService()),
            location: .userRank
        )
    )
}
