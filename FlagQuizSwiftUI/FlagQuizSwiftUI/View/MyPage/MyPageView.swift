//
//  MyPageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import SwiftUI

enum MyPageMenuType: String, Identifiable {
    case editUserName
    case maker
    case privacyPolicy
    case termsOfUse
    case openSourceLicense
    
    
    var id: String {
        self.rawValue
    }
}

struct MyPageView: View {
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @StateObject private var viewModel: MyPageViewModel
    @State private var presentingMenu: MyPageMenuType?
    
    init(viewModel: MyPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                userNameSettings
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 15, style: .circular))
                    .backgroundStyle(.background)
                
                generalSettings
                    .padding()
                    .background(in: RoundedRectangle(cornerRadius: 15, style: .circular))
                    .backgroundStyle(.background)
                
                
                
                Button {
                    //TODO: - 회원탈퇴
                } label: {
                    Text("mypage.accountDeletion.title")
                        .font(.footnote)
                        .foregroundStyle(Color(.secondaryLabel))
                }
                .padding(.horizontal)
                
            }
            .padding(.vertical)
        }
        .background {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)
        }
        .sheet(item: $presentingMenu) { linkType in
            switch linkType {
            case .privacyPolicy: SafariWebView(
                url: URL(
                    string: "https://tulip-pancreas-c37.notion.site/c8a859249c9a4bc78d32de298f726824"
                )!
            ).ignoresSafeArea()
            case .editUserName:
                EmptyView()
                
            case .maker:
                EmptyView()
            case .termsOfUse:
                EmptyView()
            case .openSourceLicense:
                EmptyView()
            }
        }
        .task {
            await viewModel.load()
        }
        .safeAreaInset(edge: .bottom, content: {
            let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? AnyObject
            let version = nsObject as! String
            Text("mypage.version.information.\(version)")
                .font(.footnote)
                .foregroundStyle(Color(.secondaryLabel))
        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("mypage.navigationTitle")
    }
    
    @ViewBuilder
    var userNameSettings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("mypage.userInfo.title")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            
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
            .padding(.vertical, 8)
            
        }

    }
    
    @ViewBuilder
    var generalSettings: some View {
        VStack(alignment: .trailing, spacing: 24) {
            Button {
                //TODO: 만든이
            } label: {
                Text("mypage.maker.title")
                    .foregroundStyle(.foreground)
            }
            
            Button {
                presentingMenu = .privacyPolicy
            } label: {
                Text("mypage.privacyPolicy.title")
                    .foregroundStyle(.foreground)
            }
            
            
            Button {
                //TODO: 서비스 이용약관
            } label: {
                Text("mypage.servicePolicy.title")
                    .foregroundStyle(.foreground)
            }
            
            Button {
                //TODO: 오픈소스 라이선스
            } label: {
                Text("mypage.openSourceLicense.title")
                    .foregroundStyle(.foreground)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

#Preview {
    NavigationStack {
        MyPageView(viewModel: .init(container: .init(services: StubService())))
            .environmentObject(NavigationModel())
            .environmentObject(
                AuthenticationViewModel(
                    container: .init(
                        services: StubService()
                    )
                )
            )
    }
    
}
