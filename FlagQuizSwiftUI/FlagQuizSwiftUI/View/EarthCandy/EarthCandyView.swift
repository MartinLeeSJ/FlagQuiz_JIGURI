//
//  EarthCandyView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import SwiftUI

struct EarthCandyView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var container: DIContainer
    @EnvironmentObject private var newsViewModel: NewsViewModel
    @EnvironmentObject private var viewModel: EarthCandyModel
    
    @State private var showDetail: Bool = false
    
    private let isShowingInStoreView: Bool
    
    init(isShowingInStoreView: Bool = false) {
        self.isShowingInStoreView = isShowingInStoreView
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Image("EarthCandy")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 20)
                .padding(8)
                .shadow(
                    color: scheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5) ,
                    radius: scheme == .dark ? 5 : 1
                )
            
            Group {
                if let point = viewModel.earthCandy?.point {
                    Text(point, format: .number)
                } else {
                    Text(0, format: .number)
                    
                }
            }
            .font(.system(.subheadline, design: .monospaced))
            .fontWeight(.medium)
            
            if !isShowingInStoreView {
                Image(systemName: "plus", variableValue: 0.5)
                    .font(.caption)
                    .fontWeight(.black)
                    .padding(.trailing, 8)
            }
        }
        .task {
            viewModel.observe()
        }
        .onTapGesture {
            if !isShowingInStoreView {
                guard let isAnonymous = newsViewModel.isAnonymousUser() else { return }
                if isAnonymous {
                    newsViewModel.setLinkingLocation(.reward)
                } else {
                    showDetail = true
                }
            }
        }
        .fullScreenCover(isPresented: $showDetail) {
            EarthCandyRewardView(viewModel: .init(container: container))
        }
        
    }
}



#Preview {
    let container = DIContainer(services: StubService())
    return EarthCandyView()
        .environmentObject(
            EarthCandyModel(
              container: container
            )
        )
        .environmentObject(container)
}
