//
//  DBError.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

enum DBError: Error {
    case custom(Error)
    case emptyData
    case fetchingError
    case decodingError
    case invalidObject
    case invalidSelf
}
