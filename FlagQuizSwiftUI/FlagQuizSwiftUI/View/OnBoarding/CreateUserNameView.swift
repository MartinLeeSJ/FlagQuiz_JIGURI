//
//  CreateUserNameView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/15/24.
//

import SwiftUI
import Combine

struct CreateUserNameView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject private var viewModel: CreateUserNameViewModel
    
    init(viewModel: CreateUserNameViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geo in
            if geo.size.width < geo.size.height {
                verticalContent
            } else {
                horizontalContent
            }
        }
        .onChange(of: viewModel.didCreatedUserName) { didCreated in
            if didCreated {
                container.navigationModel.navigate(to: OnBoardingDestination.createFrog)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    var verticalContent: some View {
        VStack {
            talkingFrog
            userNameInputView
        }
        .padding()
        .background(Color.fqAccent)
        .background(ignoresSafeAreaEdges: .all)
       
    }
    
    var horizontalContent: some View {
        HStack(spacing: 32) {
            talkingFrog
            userNameInputView
        }
        .padding()
        .background(Color.fqAccent)
        .background(ignoresSafeAreaEdges: .all)
    }
    
    var talkingFrog: some View {
        VStack {
            Spacer()
            
            Image("frogHeadBig")
                .resizable()
                .scaledToFit()
                .frame(width: 180)
            
            Image("LetterBoxCenter")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Text("createUserNameView.how.can.i.call.you")
                        .font(.custom(FontName.pixel, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.3)
                        .foregroundStyle(.black)
                        .offset(y: -24)
                }
            
            Spacer()
        }
    }
    
    var userNameInputView: some View {
        UserNameInputView(userName: $viewModel.userName) {
            viewModel.createUserName()
        }
        .frame(maxHeight: 250, alignment: .top)
        .background(in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    CreateUserNameView(
        viewModel: .init(
            container: .init(
                services: StubService()
            )
        )
    )
    .environmentObject(DIContainer(services: StubService()))
    
}
