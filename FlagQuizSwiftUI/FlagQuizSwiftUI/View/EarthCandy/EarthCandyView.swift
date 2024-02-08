//
//  EarthCandyView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/5/24.
//

import SwiftUI

struct NewsViewEarthCandyView: View {
    @EnvironmentObject private var newsViewModel: NewsViewModel
    @EnvironmentObject private var container: DIContainer
    
    @AppStorage(UserDefaultKey.EarthCandyRewardInfoBalloonPresentedDate)
    private var presentingBalloonDate: Double = Date(timeIntervalSinceReferenceDate: 0).timeIntervalSinceReferenceDate
    
    
    @State private var showDetail: Bool = false
    @State private var isBalloonPresented: Bool = false
    

    var body: some View {
        HStack {
            EarthCandyView()
            
            Image(systemName: "plus", variableValue: 0.5)
                .font(.caption)
                .fontWeight(.black)
                .padding(.trailing, 8)
        }
        .onTapGesture {
            guard let isAnonymous = newsViewModel.isAnonymousUser() else { return }
            if isAnonymous {
                newsViewModel.setLinkingLocation(.reward)
            } else {
                showDetail = true
                presentingBalloonDate = Date.now.timeIntervalSinceReferenceDate
                isBalloonPresented = false
            }
        }
        .fullScreenCover(isPresented: $showDetail) {
            EarthCandyRewardView(viewModel: .init(container: container))
        }
        .onAppear {
            checkLastPresentedBalloonDate()
        }
        .informationBalloon(
            isPresented: $isBalloonPresented,
            ballonColor: .fqAccent,
            cornerRadius: 4) {
                Text(
                    String(
                        localized: "newsViewEarthCandyView.balloon.title",
                        defaultValue: "Claim your daily rewards"
                    )
                )
                .font(.caption)
                .fontWeight(.medium)
                .padding(.vertical, 4)
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 10)
                    .padding(.trailing, 8)
            }
    }
    
    private func checkLastPresentedBalloonDate() {
        let lastPresented: Date = Date(timeIntervalSinceReferenceDate: presentingBalloonDate)
        let calendar: Calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: lastPresented, to: .now)
        
        guard let hours = components.hour else {
            return
        }
        
        if calendar.isDateInYesterday(lastPresented) || abs(hours) >= 24 {
            withAnimation(.easeInOut.delay(2)) {
                isBalloonPresented = true
            }
        }
    }
}

struct ItemStoreEarthCandyView: View {
    var body: some View {
        EarthCandyView()
    }
}

fileprivate struct EarthCandyView: View {
    @Environment(\.colorScheme) private var scheme
    @EnvironmentObject private var viewModel: EarthCandyModel
    
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
        }
        .task {
            viewModel.observe()
        }
    }
}

