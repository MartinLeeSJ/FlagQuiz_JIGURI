//
//  ServiceError.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import Foundation

enum ServiceError: Error {
    case nilSelf
    case custom(Error)
}
