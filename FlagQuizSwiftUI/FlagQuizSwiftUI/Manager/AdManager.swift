//
//  AdManager.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/16/24.
//

import SwiftUI
import AppTrackingTransparency

final class AdManager: ObservableObject {
    
    func requestTracking(completion: @escaping (ATTrackingManager.AuthorizationStatus) -> Void) {
        ATTrackingManager.requestTrackingAuthorization(completionHandler: completion)
    }
}
