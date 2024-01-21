//
//  FQEarthCandyRewardRecordObject.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/19/24.
//

import Foundation
import FirebaseFirestore

struct FQEarthCandyRewardRecordObject: Codable {
    @DocumentID var id: String?
    let dailyRewardRecord: Timestamp
    let adRewardRecord: Timestamp
    let adRewardTrial: Int
}

extension FQEarthCandyRewardRecordObject {
    func toModel() -> FQEarthCandyRewardRecord {
        .init(
            dailyRewardRecord: dailyRewardRecord.dateValue(),
            adRewardRecord: adRewardRecord.dateValue(),
            adRewardTrial: .safeValue(from: adRewardTrial)
        )
    }
}
