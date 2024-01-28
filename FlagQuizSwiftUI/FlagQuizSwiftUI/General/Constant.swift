//
//  Constant.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

enum Constant {}

typealias CollectionKey = Constant.CollectionKey
typealias LocalizableTable = Constant.LocalizableTable
typealias ServiceLangCode = Constant.ServiceLangCode
typealias FontName = Constant.FontName
typealias UserDefaultKey = Constant.UserDefaultKey

extension Constant {
    struct CollectionKey {
        static let Users: String = "Users"
        static let UserQuizStats: String = "UserQuizStats"
        static let CountryQuizStats: String = "CountryQuizStats"
        static let QuizRecord: String = "QuizRecord"
        static let Frogs: String = "Frogs"
        static let Items: String = "Items"
        static let EarthCandy: String = "EarthCandy"
        static let EarthCandyRewardRecord: String = "EarthCandyRewardRecord"
        static let UserItem: String = "UserItem"
    }
    
    struct LocalizableTable {
        static let button: String = "ButtonLocalizable"
        static let general: String = "General"
    }
    
    enum ServiceLangCode: String, Codable {
        case EN = "en"
        case KO = "ko"
    }
    
    struct FontName {
        static let pixel = "NeoDunggeunmoPro-Regular"
    }
    
    struct UserDefaultKey {
        static let ShowOnboarding: String = "ShowOnBoarding"
        static let ShowATTConsent: String = "ShowATTConsent"
        static let FirstTimeToGetEarthCandyReward: String = "FirstTimeToGetEarthCandyReward"
    }
}
