//
//  EarthCandyRewardView.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import SwiftUI

struct EarthCandyRewardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EarthCandyRewardViewModel
    
    init(viewModel: EarthCandyRewardViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 32)
                
                dailyRewardContent
                
                adRewardContent
                
                Spacer()

            }
            .toolbar {
                Button("close") {
                    dismiss()
                }
                .shadow(radius: 5)
            }
            .navigationTitle("rewardView.title") //오늘의 무료 지구 알사탕
            .navigationBarTitleDisplayMode(.inline)
            .task {
                viewModel.observe()
            }
        }
    }
    
    @ViewBuilder
    private var dailyRewardContent: some View {
        Text("rewardView.daily.content.title")//일일 출석 리워드
            .font(.headline)
            .background(.background)
            .offset(y: 24)
            .zIndex(1)
        
        HStack {
            VStack {
                HStack {
                    Image("EarthCandy")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 30)
                    
                    Text(FQEarthCandy.dailyRewardCandyPoint, format: .number)
                        .font(.title)
                }
                Text("rewardView.daily.content.description")//출석체크 시 받을 수 있는 리워드
                    .font(.caption)
            }
            
            Spacer()
           
            Button {
                viewModel.send(.getDailyReward)
            } label: {
                if let canGetDailyReward = viewModel.canGetDailyReward,
                   canGetDailyReward {
                    Text("rewardView.daily.content.button.title.receive")//받기
                } else {
                    Text("rewardView.daily.content.button.title.preparing")//준비 중
                }
            }
            .earthCandyRewardViewButton(!(viewModel.canGetDailyReward ?? false))
       
        }
        .rewardContentContainer()
    }
    
    @ViewBuilder
    private var adRewardContent: some View {
        Text("rewardView.ad.content.title")//광고 시청 리워드
            .font(.headline)
            .background(.background)
            .offset(y: 24)
            .zIndex(1)
        
        HStack {
            VStack {
                HStack {
                    Image("EarthCandy")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 30)
                    
                    Text(FQEarthCandy.adRewardCandyPoint, format: .number)
                        .font(.title)
                }
                Text("rewardView.ad.content.description")//1회 시청 시 받을 수 있는 리워드
                    .font(.caption)
            }
            
            Spacer()
            RewardedAdButton { reward in
                viewModel.send(.getAdReward)
            } buttonLabel: {
                Text("rewardView.ad.content.button.description.\(viewModel.restCountOfAdReward ?? 0)")
                //오늘 남은 횟수 \(viewModel.restCountOfAdReward ?? 0)번
            }
            .earthCandyRewardViewButton((viewModel.restCountOfAdReward ?? 0) <= 0)
       
        }
        .rewardContentContainer()
    }
}

struct RewardContentContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .padding(.vertical)
            .background {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.fqAccent, lineWidth: 2)
            }
            .padding()
    }
}

struct EarthCandyRewardViewButtonModifier: ViewModifier {
    private let disabled: Bool
    
    init(_ disabled: Bool) {
        self.disabled = disabled
    }
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(in: .rect(cornerRadius: 10))
            .backgroundStyle(.thinMaterial)
            .disabled(disabled)
        
    }
}

extension View {
    func rewardContentContainer() -> some View {
        self.modifier(RewardContentContainer())
    }
    
    func earthCandyRewardViewButton(_ disabled: Bool) -> some View {
        self.modifier(EarthCandyRewardViewButtonModifier(disabled))
    }
}



#Preview {
    EarthCandyRewardView(
        viewModel: .init(
            container: DIContainer(
                services: StubService()
            )
        )
    )
}
