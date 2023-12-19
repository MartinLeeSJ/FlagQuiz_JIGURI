//
//  FQCountry.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

protocol FQCountryRenderer {
    var id: FQCountryISOCode { get }
    var name: FQCountryName { get }
    var flagLinks: FQFlagLinks { get }
}

struct FQCountry: FQCountryRenderer, Codable {
    let id: FQCountryISOCode
    let name: FQCountryName
    let flagLinks: FQFlagLinks
    
    enum CodingKeys: String, CodingKey {
        case id = "ccn3"
        case name
        case flagLinks = "flags"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let ccn3: String = try container.decode(String.self, forKey: .id)
        self.id = FQCountryISOCode(ccn3)
        self.name = try container.decode(FQCountryName.self, forKey: .name)
        self.flagLinks = try container.decode(FQFlagLinks.self, forKey: .flagLinks)
    }
}





