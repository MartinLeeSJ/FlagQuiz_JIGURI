//
//  NotificationManager.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 1/9/24.
//

import Foundation
import UserNotifications

enum FrogStateNotificationType: Int {
    case frogStateGood = 2
    case frogStateSoSo = 1
    case frogStateBad = 0
    
    var id: String {
        switch self {
        case .frogStateGood: "frogStateGood"
        case .frogStateSoSo: "frogStateSoSo"
        case .frogStateBad: "frogStateBad"
        }
    }
    
    var title: String {
        switch self {
        case .frogStateGood:
            String(localized: "frog.state.notification.title.frogStateGood")
        case .frogStateSoSo:
            String(localized: "frog.state.notification.title.frogStateSoSo")
        case .frogStateBad:
            String(localized: "frog.state.notification.title.frogStateBad")
        }
    }
    
    var body: String {
        switch self {
        case .frogStateGood:
            String(localized: "frog.state.notification.body.frogStateGood")
        case .frogStateSoSo:
            String(localized: "frog.state.notification.body.frogStateSoSo")
        case .frogStateBad:
            String(localized: "frog.state.notification.body.frogStateBad")
        }
    }
    
    var baseTimeInterval: TimeInterval {
        //기본단위 4시간
//        .init(4 * 60 * 60)
        // TEST
        .init(10)
    }
    
  
    
   
}

class NotificationManager: ObservableObject {
    private let center = UNUserNotificationCenter.current()
    
    public func requestAuthorization() async {
        do {
            try await center.requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            // TODO: Error Handling
            print(error.localizedDescription)
        }
    }
    
    public func addFrogStateNotification(when state: FrogState) {
        // .great = 3 에선 3개의 알림을
        // .frogStateGood -> 4시간
        // ....SoSo -> 8시간
        // ....Bad -> 12시간
        for index in 0..<state.rawValue {
            guard let type = FrogStateNotificationType(rawValue: index) else { continue }
            // 차이만큼 4시간 배수의 알림 시간 설정
            let stateValueDifference = Double(state.rawValue - type.rawValue)
            let timeInterval: TimeInterval = type.baseTimeInterval * stateValueDifference
            
            scheduleFrogStateNotification(of: type, after: timeInterval)
        }
    }
    
    private func scheduleFrogStateNotification(of type: FrogStateNotificationType, after timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = type.title
        content.body = type.body
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(
            identifier: type.id,
            content: content,
            trigger: trigger
        )
        
        center.add(request) { error in
            if let error {
                //TODO: ErrorHandling
                print(error.localizedDescription)
            }
        }
    }
}
