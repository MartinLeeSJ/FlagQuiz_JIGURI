//
//  FQEarthCandyRewardRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import Foundation

struct FQEarthCandyRewardRecord {
    private var dailyRewardRecord: Date
    private var didGetDailyReward: Bool
    private var adRewardRecord: Date
    private var adRewardTrial: AdRewardTrial
    
    init(
        dailyRewardRecord: Date,
        didGetDailyReward: Bool,
        adRewardRecord: Date,
        adRewardTrial: AdRewardTrial
    ) {
        self.dailyRewardRecord = dailyRewardRecord
        self.didGetDailyReward = didGetDailyReward
        self.adRewardRecord = adRewardRecord
        self.adRewardTrial = adRewardTrial
    }
    
    enum AdRewardTrial: Int {
        case first = 0
        case second
        case third
        case finished
        
        static let maximumTrialCount: Int = 3
    }
    
    
    /// 데일리리워드를 받을 수 있는지 확인하는 메서드
    /// 어제 데일리리워드를 받은 기록이 있다면 didGetDailyReward를 false로 바꾸고
    /// true를 리턴한다.
    /// - Returns: 데일리 리워드를 받을 수 있는지 여부의 불리언값
    mutating public func checkIfCanGetDailyReward() -> Bool {
        if checkUpdatedYesterdayOrMore(dailyRewardRecord) {
            didGetDailyReward = false
            return !didGetDailyReward
        }
        
        return !didGetDailyReward
    }
    
    /// 데일리리워드를 받은 후 실행하는 기록 메서드
    mutating public func recordDidGetDailyReward() {
        self.dailyRewardRecord = .now
        self.didGetDailyReward = true
    }
    
    /// 보상형 광고 리워드를 받을 수 있는 남은 횟수를 알려주는 메서드
    /// 어제 받은 기록이 있다면 다시 adRewardTrial을 .first ( RawValue == 0) 로 바꿔주고
    /// 최대 시도 횟수 3회에서 현재 adRewardTrial의 RawValue의 값을 빼서 리턴한다
    /// - Returns: 보상형 광고 리워드를 받을 수 있는 남은 횟수
    mutating public func checkRestAdRewardTrialCount() -> Int {
        if checkUpdatedYesterdayOrMore(adRewardRecord) {
            resetOldAdRewardTrial()
        }
        
        return AdRewardTrial.maximumTrialCount - adRewardTrial.rawValue
    }
    
    mutating public func getAdReward() {
        resetOldAdRewardTrial()
        
        guard adRewardTrial != .finished else { return }
        
        var newTrialCount = self.adRewardTrial.rawValue + 1
        newTrialCount = min(AdRewardTrial.maximumTrialCount, newTrialCount)
        
        self.adRewardTrial = AdRewardTrial(rawValue: newTrialCount)!
        
        adRewardRecord = .now
    }
    
    mutating private func resetOldAdRewardTrial() {
        guard checkUpdatedYesterdayOrMore(adRewardRecord) else { return }
        self.adRewardTrial = .first
    }
    
    static let reward: Int = 100
    
    private func checkUpdatedYesterdayOrMore(_ date: Date) -> Bool {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now) else {
            return false
        }
        
        return (date < yesterday) || Calendar.current.isDateInYesterday(date)
    }
}
