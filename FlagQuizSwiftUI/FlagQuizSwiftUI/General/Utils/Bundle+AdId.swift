//
//  Bundle+AdId.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/17/24.
//

import Foundation

extension Bundle {
    var newsViewBannerAdID: String {
        guard let urlPath = self.url(forResource: "Ad", withExtension: "plist") else { return "" }
        guard let resource = try? NSDictionary(contentsOf: urlPath, error: ()) else { return "" }
        guard let key = resource["NewsViewBanner"] as? String else {
            fatalError("Can not find newsViewBannerAdID")
        }
        
        return key
    }
    
    var earthCandyRewardAdID: String {
        guard let urlPath = self.url(forResource: "Ad", withExtension: "plist") else { return "" }
        guard let resource = try? NSDictionary(contentsOf: urlPath, error: ()) else { return "" }
        guard let key = resource["EarthCandyReward"] as? String else {
            fatalError("Can not find earthCandyRewardAdID")
        }
        
        return key
    }
}
