//
//  APIError.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/13/23.
//

import Foundation

enum APIError: Error {
    case invalidated
    case invalidURL
    case invalidResponse
    case httpStatusError(statusCode: Int, description: String)
    case emptyData
    case custom(Error)
}
