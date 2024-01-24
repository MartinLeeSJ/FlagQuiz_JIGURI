//
//  UserNameSettingSection.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/23/24.
//

import SwiftUI

struct UserNameSettingSection: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var container: DIContainer
    
    @ObservedObject private var viewModel: MyPageViewModel
    @Binding private var presentingMenu: MyPageMenuType?
    @State private var linkingLoginLocation: LinkingLoginLocation?
    
    init(
        viewModel: MyPageViewModel,
        presentingMenu: Binding<MyPageMenuType?>
    ) {
        self.viewModel = viewModel
        self._presentingMenu = presentingMenu
    }
    
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("mypage.userInfo.title")
                        .foregroundStyle(.secondary)
                    
                    if let isAnonymous = viewModel.isAnonymousUser(),
                       isAnonymous {
                        Text("mypage.userInfo.anonymous.badge")
                    }
                }
                .font(.caption)
                
                
                if let userName = viewModel.user?.userName {
                    Text(!userName.isEmpty ? userName : String(localized: "mypage.userName.placeholder"))
                        .font(!userName.isEmpty ?
                            .custom(FontName.pixel, size: 24) :
                                .system(size: 24)
                        )
                        .italic(userName.isEmpty)
                } else {
                    Text("mypage.userName.placeholder")
                }
                
                HStack {
                    Spacer()
                    if let isAnonymous = viewModel.isAnonymousUser(),
                       isAnonymous {
                        Button {
                            linkingLoginLocation = .mypage
                        } label: {
                            Text("mypage.logInButton.title")
                                .font(.subheadline)
                                .foregroundStyle(.foreground)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                        }
                        .overlay {
                            Capsule()
                                .stroke()
                        }
                        .sheet(item: $linkingLoginLocation) { location in
                            LinkingLoginView(
                                viewModel: .init(container: container),
                                location: location
                            )
                        }
                        
                    } else {
                        Button {
                            navigationModel.toRoot()
                            authViewModel.send(.signOut)
                        } label: {
                            Text("mypage.logOutButton.title")
                                .font(.subheadline)
                                .foregroundStyle(.foreground)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                        }
                        .overlay {
                            Capsule()
                                .stroke()
                        }
                        
                        Button {
                            presentingMenu = .editUserName
                        } label: {
                            Text("mypage.editUserNameButton.title")
                                .font(.subheadline)
                                .foregroundStyle(.foreground)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                        }
                        .overlay {
                            Capsule()
                                .stroke()
                        }
                    }
                    
                    
                }
                .padding(.vertical, 8)
                
            }
        }
    }
    
        
        
    
}
