//
//  FQEarthCandyRewardRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import Foundation

struct FQEarthCandyRewardRecord {
    private var dailyRewardRecord: Date
    private var adRewardRecord: Date
    private var adRewardTrial: AdRewardTrial
    
    init(
        dailyRewardRecord: Date,
        adRewardRecord: Date,
        adRewardTrial: AdRewardTrial
    ) {
        self.dailyRewardRecord = dailyRewardRecord
        self.adRewardRecord = adRewardRecord
        self.adRewardTrial = adRewardTrial
    }
    
    enum AdRewardTrial: Int {
        case first = 0
        case second
        case third
        case finished
        
        static let maximumTrialCount: Int = 3
        static func safeValue(from rawValue: Int) -> AdRewardTrial {
            var value: Int = max(self.first.rawValue, rawValue)
            value = min(self.finished.rawValue, value)
            return .init(rawValue: value)!
        }
    }
    
    
    /// 데일리리워드를 받을 수 있는지 확인하는 메서드
    /// - Returns: 데일리 리워드를 받을 수 있는지 여부의 불리언값
    public func checkIfCanGetDailyReward() -> Bool {
        if checkUpdatedYesterdayOrMore(dailyRewardRecord) {
            return true
        }
        return false
    }
    
    public func restCountOfAdReward() -> Int {
        if checkUpdatedYesterdayOrMore(adRewardRecord) {
            return AdRewardTrial.maximumTrialCount
        }
        
        return AdRewardTrial.maximumTrialCount - adRewardTrial.rawValue
    }
    
    /// 데일리리워드를 받기 전 실행하는 메서드
    public func getDailyReward() -> FQEarthCandyRewardRecord? {
        guard checkUpdatedYesterdayOrMore(dailyRewardRecord) else { return nil }
        
        return .init(
            dailyRewardRecord: .now,
            adRewardRecord: adRewardRecord,
            adRewardTrial: adRewardTrial
        )
        
    }

    public func getAdReward() -> FQEarthCandyRewardRecord? {
        if checkUpdatedYesterdayOrMore(adRewardRecord) {
            return .init(
                dailyRewardRecord: dailyRewardRecord,
                adRewardRecord: .now,
                adRewardTrial: .second
            )
        }
        
        guard adRewardTrial != .finished else { return nil }
        
        return .init(
            dailyRewardRecord: dailyRewardRecord,
            adRewardRecord: .now,
            adRewardTrial: .safeValue(from: adRewardTrial.rawValue + 1)
        )
    }
   

    private func checkUpdatedYesterdayOrMore(_ date: Date) -> Bool {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now) else {
            return false
        }
        
        return (date < yesterday) || Calendar.current.isDateInYesterday(date)
    }
}

extension FQEarthCandyRewardRecord {
    static var initialModel: FQEarthCandyRewardRecord {
        let past = Calendar.current.date(byAdding: .day, value: -1, to: .now) ?? .init(timeIntervalSinceReferenceDate: 0)
        return .init(
            dailyRewardRecord: past,
            adRewardRecord: past,
            adRewardTrial: .first
        )
    }
    
    func toObject() -> FQEarthCandyRewardRecordObject {
        .init(
            dailyRewardRecord: .init(date: dailyRewardRecord),
            adRewardRecord: .init(date: adRewardRecord),
            adRewardTrial: adRewardTrial.rawValue
        )
    }
}
