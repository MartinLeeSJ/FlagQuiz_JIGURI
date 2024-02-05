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
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                .fontWeight(.semibold)
            }
            .navigationTitle("rewardView.title") //오늘의 무료 지구 알사탕
            .navigationBarTitleDisplayMode(.inline)
            .toastAlert($viewModel.toastAlert)
            .task {
                viewModel.observe()
            }
        }
    }
    
    @ViewBuilder
    private var dailyRewardContent: some View {
        Text("rewardView.daily.content.title")//일일 출석 리워드
            .font(.headline)
            .padding(.horizontal, 8)
            .background(.background)
            .offset(y: 24)
            .zIndex(1)
        
        HStack {
            VStack {
                HStack {
                    Image("EarthCandy")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 20)
                    
                    Text(FQEarthCandy.dailyRewardCandyPoint, format: .number)
                        .font(.title3)
                }
                Text("rewardView.daily.content.description")//출석체크 시 받을 수 있는 리워드
                    .font(.caption2)
            }
            
            Spacer()
            
            Button {
                getDailyReward()
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
            .padding(.horizontal, 8)
            .background(.background)
            .offset(y: 24)
            .zIndex(1)
        
        
        HStack {
            VStack {
                Label {
                    Text(FQEarthCandy.adRewardCandyPoint, format: .number)
                        .font(.title3)
                } icon: {
                    Image("EarthCandy")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 20)
                }
                
                Text("rewardView.ad.content.description")//1회 시청 시 받을 수 있는 리워드
                    .font(.caption2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("rewardView.ad.content.description.\(viewModel.restCountOfAdReward ?? 0)")
                    .font(.caption2)
                
                
                RewardedAdButton { reward in
                    viewModel.send(.getAdReward)
                } buttonLabel: {
                    if let restCount = viewModel.restCountOfAdReward,
                       restCount > 0 {
                        Text("rewardView.ad.content.button.title")
                    } else {
                        Text("rewardView.ad.content.button.title.ready")
                    }
                }
                .earthCandyRewardViewButton((viewModel.restCountOfAdReward ?? 0) <= 0)
            }
     
            
        }
        .frame(maxWidth: .infinity)
        .rewardContentContainer()
    }
    
    private func getDailyReward() {
        viewModel.send(.getDailyReward)
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
            .font(.subheadline)
            .foregroundStyle(disabled ? .gray : .green)
            .padding(.vertical, 4)
            .padding(.horizontal, 10)
            .background(in: .rect(cornerRadius: 10))
            .backgroundStyle(.thinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(disabled ? .gray : .fqAccent, lineWidth: 1.0)
            }
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
    EarthCandyRewardView(viewModel: EarthCandyRewardViewModel(
        container: .init(
            services: StubService()
        )
    ))
}
