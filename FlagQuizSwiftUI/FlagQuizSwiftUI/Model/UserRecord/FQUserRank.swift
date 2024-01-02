//
//  FQUserRank.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/26/23.
//

import SwiftUI

enum FQUserRank: Int, CaseIterable {
    /// totalQuizCount  < 45
    case newbie = 0
    /// totalQuizCount >= 45
    case bronze = 1
    /// totalQuizCount >= 75, Accuracy Rate >= 70%
    case silver = 2
    /// totalQuizCount >= 500, Accuracy Rate >= 75%
    case gold = 3
    /// totalQuizCount >= 1000, Accuracy Rate >= 80%
    case neighborhoodInfluencer = 4
    /// totalQuizCount >= 2000, Accuracy Rate >= 85%
    case urbanInfluencer = 5
    /// totalQuizCount >= 4000, Accuracy Rate >= 90%
    case countrywideInfluencer = 6
    /// totalQuizCount >= 4000, Accuracy Rate >= 95%
    case continentalInfluencer = 7
    /// totalQuizCount >= 4000, Accuracy Rate >= 99%
    case worldwideInfluencer = 8
    /// totalQuizCount >= 4000, Accuracy Rate >= 99.5%
    case earthGuru = 9
    
    static func evaluateOnesRank(correctQuizCount: Int, totalQuizCount: Int) -> FQUserRank {
        let accuracyNumber: Double = Double(correctQuizCount) / Double(totalQuizCount)
        guard accuracyNumber <= 1 else { return .newbie }
        
        let accuracyRate: Double = Double(floor(100 * accuracyNumber) / 100)
        
        switch (totalQuizCount, accuracyRate) {
        case (4000..., 0.995...1.00) :
            return .earthGuru
        case (4000..., 0.99...0.995) :
            return .worldwideInfluencer
        case (4000..., 0.95...0.99) :
            return .continentalInfluencer
        case (4000..., 0.9...):
            return .countrywideInfluencer
        case (2000..., 0.85...):
            return .urbanInfluencer
        case (1000..., 0.8...):
            return .neighborhoodInfluencer
        case (500..., 0.75...):
            return .gold
        case (75..., 0.7...):
            return .silver
        case (45..., _):
            return .bronze
        case (...44, _):
            return .newbie
        default:
            return .newbie
        }
    }
    
    var localizedRankName: String {
        switch self {
        case .earthGuru:
            return String(localized: "FQUserRank9", defaultValue: "Earth Guru")
        case .worldwideInfluencer:
            return String(localized: "FQUserRank8", defaultValue: "Worldwide\nInfluencer")
        case .continentalInfluencer:
            return String(localized: "FQUserRank7", defaultValue: "Continental\nInfluencer")
        case .countrywideInfluencer:
            return String(localized: "FQUserRank6", defaultValue: "Countrywide\nInfluencer")
        case .urbanInfluencer:
            return String(localized: "FQUserRank5", defaultValue: "Urban\nInfluencer")
        case .neighborhoodInfluencer:
            return String(localized: "FQUserRank4", defaultValue: "Neighborhood\nInfluencer")
        case .gold:
            return String(localized: "FQUserRank3", defaultValue: "Gold")
        case .silver:
            return String(localized: "FQUserRank2", defaultValue: "Silver")
        case .bronze:
            return String(localized: "FQUserRank1", defaultValue: "Bronze")
        case .newbie:
            return String(localized: "FQUserRank0", defaultValue: "Beginner")
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .earthGuru:
            return String(
                localized: "FQUserRank9_description",
                defaultValue: "You are a maestro.\nYour exceptional knowledge can represent the Earth."
            )
        case .worldwideInfluencer:
            return String(
                localized: "FQUserRank8_description",
                defaultValue: "Your exceptional knowledge is renowned worldwide."
            )
        case .continentalInfluencer:
            return String(
                localized: "FQUserRank7_description",
                defaultValue: "Your exceptional knowledge is on a continental scale."
            )
        case .countrywideInfluencer:
            return String(
                localized: "FQUserRank6_description",
                defaultValue: "Your extensive knowledge is acknowledged even by the country."
            )
        case .urbanInfluencer:
            return String(
                localized: "FQUserRank5_description",
                defaultValue: "Your knowledge is unparalleled within this city."
            )
        case .neighborhoodInfluencer:
            return String(
                localized: "FQUserRank4_description",
                defaultValue: "Your knowledge is unrivaled in this area."
            )
        case .gold:
            return String(
                localized: "FQUserRank3_description",
                defaultValue: "You are gold rank."
            )
        case .silver:
            return String(
                localized: "FQUserRank2_description",
                defaultValue: "You are silver rank."
            )
        case .bronze:
            return String(
                localized: "FQUserRank1_description",
                defaultValue: "You are bronze rank."
            )
        case .newbie:
            return String(
                localized: "FQUserRank0_description",
                defaultValue: "You are a beginner."
            )
        }
    }
    
    
    var medalImageName: String {
       switch self {
        case .earthGuru:
             "MedalEarthGuru"
        case .worldwideInfluencer:
            "MedalWorldwideInf"
        case .continentalInfluencer:
            "MedalContinentalInf"
        case .countrywideInfluencer:
            "MedalCountrywideInf"
        case .urbanInfluencer:
            "MedalUrbanInf"
        case .neighborhoodInfluencer:
            "MedalNeighborhoodInf"
        case .gold:
            "MedalGold"
        case .silver:
            "MedalSilver"
        case .bronze:
            "MedalBronze"
        case .newbie:
            "MedalNewbie"
        }
    }
    
    var rankUpQuizCountCriteria: (min: Int, max: Int) {
        switch self {
        case .newbie: (0, 45)
        case .bronze: (45, 75)
        case .silver: (75, 150)
        case .gold: (150, 300)
        case .neighborhoodInfluencer: (300, 450)
        case .urbanInfluencer: (450, 600)
        case .countrywideInfluencer: (600, 900)
        case .continentalInfluencer,
                .worldwideInfluencer,
                .earthGuru: (900, 900)
        }
    }
    
    var rankUpAccuracyCriteria: Double {
        switch self {
        case .newbie: 0
        case .bronze: 0
        case .silver: 70
        case .gold: 75
        case .neighborhoodInfluencer: 80
        case .urbanInfluencer: 85
        case .countrywideInfluencer: 90
        case .continentalInfluencer: 95
        case .worldwideInfluencer: 99
        case .earthGuru: 99.5
        }
    }
    
    var rankUpCriteriaDescription: (quizCount: String, accuracy: String) {
        switch self {
        case .newbie:
            ("~\(self.rankUpQuizCountCriteria.max)", "_")
        case .bronze:
            ("\(self.rankUpQuizCountCriteria.min)+", "_")
        default:
            ("\(self.rankUpQuizCountCriteria.min)+", "\(self.rankUpAccuracyCriteria)%↑")
        }
    }
}
