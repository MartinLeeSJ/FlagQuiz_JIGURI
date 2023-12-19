//
//  FQFlagLinks.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/19/23.
//

import Foundation

struct FQFlagLinks: Codable {
    let png: String?
    let svg: String?
    let alt: String?
    
    var pngURL: URL? {
        guard let png = png else { return nil }
        return URL(string: png)
    }
    
    var svgURL: URL? {
        guard let png = png else { return nil }
        return URL(string: png)
    }
}
