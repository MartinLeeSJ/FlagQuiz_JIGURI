//
//  UserNameUpdateRecord.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/12/24.
//

import Foundation

struct UserNameUpdateRecord: Codable {
    private(set) var lastUpdated: Date
    private(set) var countOfTrial: Trial
    
    init(lastUpdated: Date = .now, countOfTrial: Trial = .once) {
        self.lastUpdated = lastUpdated
        self.countOfTrial = countOfTrial
    }
    
    enum CodingKeys: CodingKey {
        case lastUpdated
        case countOfTrial
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lastUpdated =  try container.decode(Date.self, forKey: .lastUpdated)
        self.countOfTrial = try container.decode(Trial.self, forKey: .countOfTrial)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(
            lastUpdated,
            forKey: .lastUpdated
        )
        try container.encode(
            countOfTrial,
            forKey: .countOfTrial
        )
    }
    
    private var updatedYesterdayOrMore: Bool {
        guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: .now) else {
            return false
        }

        return (lastUpdated < yesterday) || Calendar.current.isDateInYesterday(lastUpdated)
    }
    
    
    enum Trial: Int, Codable {
        case once = 1
        case twice
        case third
    }
    
    private mutating func countUp() {
        guard countOfTrial != .third else {
            return
        }
        countOfTrial = Trial(rawValue: countOfTrial.rawValue + 1)!
    }
    
    public mutating func canUpdate() -> Bool {
        if updatedYesterdayOrMore {
            lastUpdated = .now
            countOfTrial = .once
            return true
        }
        
        guard countOfTrial != .third else { return false }
        
        lastUpdated = .now
        countUp()
        return true
    }
}

extension UserNameUpdateRecord: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(UserNameUpdateRecord.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return ""
        }
        return result
    }
}
