//
//  LinkingLoginLocation.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/23/24.
//

import Foundation

enum LinkingLoginLocation: String, Identifiable {
    case mypage
    case reward
    case frogStateButton
    case userRank
    case countryStat
    case userStat
    case store
    case closet
    case photoBooth
    
    var id: String {
        self.rawValue
    }
    
    var description: String {
        switch self {
        case .mypage:
            String(
                localized: "linkingLogin.mypage.description",
                defaultValue: "To access more features,\nplease create an account now."
            )
        case .reward:
            String(
                localized: "linkingLogin.reward.description",
                defaultValue: "To receive EarthCandy rewards,\nplease create an account now."
            )
        case .frogStateButton:
            String(
                localized: "linkingLogin.frogStateButton.description",
                defaultValue: "To make the frog happy,\nplease create an account now."
            )
        case .userRank:
            String(
                localized: "linkingLogin.userRank.description",
                defaultValue: "If you want to see your detailed rank,\nplease create an account now."
            )
        case .countryStat:
            String(
                localized: "linkingLogin.countryStat.description",
                defaultValue: "If you'd like to see your country stats, \n please create an account now."
            )
        case .userStat:
            String(
                localized: "linkingLogin.userStat.description",
                defaultValue: "If you'd like to see your quiz record, \n please create an account now."
            )
        case .store:
            String(
                localized: "linkingLogin.store.description",
                defaultValue: "To access the store,\nplease create an account now."
            )
        case .closet:
            String(
                localized: "linkingLogin.closet.description",
                defaultValue: "To access the closet,\nplease create an account now."
            )
            
        case .photoBooth:
            String(
                localized: "linkingLogin.photoBooth.description",
                defaultValue: "To access the photoBooth,\nplease create an account now."
            )
        }
    }
    
}
