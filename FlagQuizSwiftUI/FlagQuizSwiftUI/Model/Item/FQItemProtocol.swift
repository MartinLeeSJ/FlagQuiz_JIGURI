//
//  FQItemProtocol.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 2/3/24.
//

import Foundation

protocol FQItemProtocol {
    var id: String { get }
    var type: FQItemType { get }
    var stockName: String { get }
    func storageImagePath(equipped: Bool) -> String
}


