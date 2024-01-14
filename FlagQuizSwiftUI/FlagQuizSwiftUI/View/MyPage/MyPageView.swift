//
//  MyPageView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/4/24.
//

import SwiftUI

enum MyPageMenuType: String, Identifiable {
    case editUserName
    case info
    case askTo
    case maker
    case privacyPolicy
    case termsOfUse
    case openSourceLicense
    
    var id: String {
        self.rawValue
    }
}

struct MyPageView: View {
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var navigationModel: NavigationModel
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    
    @StateObject private var viewModel: MyPageViewModel
    @StateObject private var infoViewModel: InformationViewModel = .init()
    
    @State private var presentingMenu: MyPageMenuType?
    @State private var presentReallyDelete: Bool = false
    
    init(viewModel: MyPageViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.thinMaterial)
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    userNameSettings
                        .myPageContainer()
                    
                    pinnedInformation
                    
                    generalSettings
                        .myPageContainer()
                    
                    deleteAccountButton
                    
                }
                .padding(.vertical)
            }
            .sheet(item: $presentingMenu) { linkType in
                switch linkType {
                case .askTo:
                    // TODO:
                    Text("Test")
                case .info:
                    InformationView(
                        pinnedInfo: infoViewModel.pinnedInfo,
                        infos: infoViewModel.infos.filter { !$0.pinned }
                    )
                case .privacyPolicy:
                    SafariWebView(
                        url: URL(
                            string: "https://tulip-pancreas-c37.notion.site/c8a859249c9a4bc78d32de298f726824"
                        )!
                    ).ignoresSafeArea()
                case .editUserName:
                    EditUserNameView(
                        viewModel: .init(container: container),
                        user: viewModel.user
                    )
                    .environmentObject(viewModel)
                    
                case .maker:
                    MakerView()
                    
                case .termsOfUse:
                    SafariWebView(
                        url: URL(
                            string: "https://tulip-pancreas-c37.notion.site/845bf34e3bc946c6946ea7550dcb4579?pvs=4"
                        )!
                    ).ignoresSafeArea()
                case .openSourceLicense:
                    SafariWebView(
                        url: URL(
                            string: "https://tulip-pancreas-c37.notion.site/2c6e88dc62054d95b2571024857ce9af?pvs=4"
                        )!
                    ).ignoresSafeArea()
                }
            }
            .task {
                await viewModel.load()
                await infoViewModel.load()
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
    var pinnedInformation: some View {
        if let pinnedInfo = infoViewModel.pinnedInfo {
            PinnedInformation(info: pinnedInfo) {
                presentingMenu = .info
            }
            .myPageContainer()
        }
    }
    
    @ViewBuilder
    var generalSettings: some View {
        VStack(alignment: .trailing, spacing: 24) {
            Button {
                presentingMenu = .info
            } label: {
                if !infoViewModel.infos.isEmpty {
                    Text(infoViewModel.infos.count, format: .number)
                        .font(.caption.bold())
                        .foregroundStyle(.fqBg)
                        .padding(.vertical, 2)
                        .padding(.horizontal, 6)
                        .background(in: Capsule(style: .continuous))
                        .backgroundStyle(.red)
                }
                
                Text("mypage.info.title")
                    .foregroundStyle(.foreground)
                    .opacity(infoViewModel.infos.isEmpty ? 0.2 : 1)
            }
            .disabled(infoViewModel.infos.isEmpty)
            
            
            Button {
                presentingMenu = .maker
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
                presentingMenu = .termsOfUse
            } label: {
                Text("mypage.servicePolicy.title")
                    .foregroundStyle(.foreground)
            }
            
            Button {
                presentingMenu = .openSourceLicense
            } label: {
                Text("mypage.openSourceLicense.title")
                    .foregroundStyle(.foreground)
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    var deleteAccountButton: some View {
        Button {
            presentReallyDelete = true
        } label: {
            Text("mypage.accountDeletion.title")
                .font(.footnote)
                .foregroundStyle(Color(.secondaryLabel))
        }
        .padding(.horizontal)
        .alert(
            "mypage.reallyDelete.title",
            isPresented: $presentReallyDelete
        ) {
            Button("mypage.reallyDelete.cancel", role: .cancel) {
                presentReallyDelete = false
            }
            
            Button("mypage.reallyDelete.delete", role: .destructive ) {
                presentReallyDelete = false
                Task {
                    await viewModel.deleteAccount()
                }
            }
        }
    }
}

struct MyPageContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(in: RoundedRectangle(cornerRadius: 15, style: .circular))
            .backgroundStyle(.background)
    }
}

extension View {
    func myPageContainer() -> some View {
        self.modifier(MyPageContainer())
    }
}

#Preview {
    NavigationStack {
        MyPageView(viewModel: .init(container: .init(services: StubService())))
            .environmentObject(DIContainer(services: StubService()))
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
