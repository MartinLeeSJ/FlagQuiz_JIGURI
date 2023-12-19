//
//  APIError.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case custom(Error)
}
