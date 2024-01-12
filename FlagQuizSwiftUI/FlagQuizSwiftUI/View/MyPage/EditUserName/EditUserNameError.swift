//
//  EditUserNameError.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/12/24.
//

import Foundation

enum EditUserNameError: LocalizedError {
    case endOfTrial
    case invalidRequest
    case failedToUpdate
    
    
    var errorDescription: String? {
        switch self {
        case .endOfTrial:
            String(
                localized: "editUserNameError.endOfTrial.description",
                defaultValue: "Username Change Limit Reached"
            )
        case .invalidRequest:
            String(
                localized: "editUserNameError.invalidRequest.description",
                defaultValue: "Unauthorized Access Attempt"
            )
        case .failedToUpdate:
            String(
                localized: "editUserNameError.failedToUpdate.description",
                defaultValue: "Update Failed"
            )
        }
    }
    
    var failureReason: String? {
        switch self {
        case .endOfTrial:
            String(
                localized: "editUserNameError.endOfTrial.failureReason",
                defaultValue: "You have exhausted your daily limit for changing your username. Please try again tomorrow."
            )
        case .invalidRequest:
            String(
                localized: "editUserNameError.invalidRequest.failureReason",
                defaultValue: "For security reasons, your request has been denied"
            )
        case .failedToUpdate:
            String(
                localized: "editUserNameError.failedToUpdate.failureReason",
                defaultValue: "Please check your internet connection and try again"
            )
        }
    }
}
