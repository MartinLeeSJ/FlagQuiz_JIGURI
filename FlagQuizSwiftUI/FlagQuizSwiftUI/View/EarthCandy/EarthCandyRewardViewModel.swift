//
//  EarthCandyRewardViewModel.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/19/24.
//

import SwiftUI
import Combine

final class EarthCandyRewardViewModel: ObservableObject {
    @Published var record: FQEarthCandyRewardRecord? {
        didSet {
            canGetDailyReward = record?.checkIfCanGetDailyReward()
            restCountOfAdReward = record?.restCountOfAdReward()
        }
    }
    @Published var canGetDailyReward: Bool?
    @Published var restCountOfAdReward: Int?
    @Published var toastAlert: ToastAlert?
 
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()
    
    enum Action {
        case getDailyReward
        case getAdReward
    }
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func observe() {
        guard let userId = container.services.authService.checkAuthenticationState() else {
            //TODO: // 유효하지 않아 불러올 수 없음을 알리는 오류
            return
        }

        container.services.earthCandyService.getEarthCandyRewardRecord(ofUser: userId)
            .flatMap { [weak self] record in
                guard let self else {
                    return Fail<FQEarthCandyRewardRecord?, ServiceError>(error: .nilSelf).eraseToAnyPublisher()
                }
                
                if record != nil {
                    return self.container.services.earthCandyService.observeEarthCandyRewardRecord(ofUser: userId)
                        .eraseToAnyPublisher()
                }
                
                return self.container.services.earthCandyService.recordEarthCandyRewardRecord(.initialModel, userId: userId)
                    .flatMap { _ in
                        self.container.services.earthCandyService.observeEarthCandyRewardRecord(ofUser: userId)
                            .eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { completion in
                
            } receiveValue: { [weak self] record in
                self?.record = record
            }
            .store(in: &cancellables)
        
           
    }
        
    func send(_ action: Action) {
        switch action {
        case .getDailyReward:
            getDailyReward()
        case .getAdReward:
            getAdReward()
        }
    }
    
    
    
    
    private func getDailyReward() {
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        guard let canGetDailyReward, canGetDailyReward == true else { return }
        guard let addingRecord = record?.getDailyReward() else { return }

        container.services.earthCandyService.recordEarthCandyRewardRecord(
            addingRecord,
            userId: userId
        ).flatMap { [weak self] _ in
            guard let self else {
                return Fail<Void, ServiceError>(error: ServiceError.nilSelf).eraseToAnyPublisher()
            }
            
            return container.services.earthCandyService.updateCandy(
                FQEarthCandy.dailyRewardCandyPoint,
                ofUser: userId
            )
            .eraseToAnyPublisher()
        }
        .sink { [weak self] completion in
            switch completion {
            case .finished:
                self?.toastAlert = .init(
                    message: String(
                        localized: "toastAlert.get.daily.reward.\(FQEarthCandy.dailyRewardCandyPoint)"
                    )
                )
            case .failure:
                self?.toastAlert = .init(
                    style: .failed,
                    message: String(
                        localized: "toastAlert.failed.to.get.daily.reward"
                    )
                )
            }
        } receiveValue: { _ in
            
        }
        .store(in: &cancellables)
    }
    
    /// 광고리워드를 받은 후 실행하는 기록 메서드
    private func getAdReward() {
        guard let userId = container.services.authService.checkAuthenticationState() else { return }
        guard let restCountOfAdReward, restCountOfAdReward > 0 else { return }
        guard let addingRecord = record?.getAdReward() else { return }
        
        container.services.earthCandyService.recordEarthCandyRewardRecord(
            addingRecord,
            userId: userId
        ).flatMap { [weak self] _ in
            guard let self else {
                return Fail<Void, ServiceError>(error: ServiceError.nilSelf).eraseToAnyPublisher()
            }
            return container.services.earthCandyService.updateCandy(
                FQEarthCandy.adRewardCandyPoint,
                ofUser: userId
            )
            .eraseToAnyPublisher()
        }
        .sink { [weak self] completion in
            switch completion {
            case .finished:
                self?.toastAlert = .init(
                    message: String(
                        localized: "toastAlert.get.ad.reward.\(FQEarthCandy.adRewardCandyPoint)"
                    )
                )
            case .failure:
                self?.toastAlert = .init(
                    style: .failed,
                    message: String(
                        localized: "toastAlert.failed.to.get.ad.reward"
                    )
                )
            }
        } receiveValue: { _ in
            
        }
        .store(in: &cancellables)

    }
   
}
