//
//  AppDelegate.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import UIKit
import UserNotifications

import FirebaseCore
import FirebaseMessaging

import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        googleAdMobService()
        
        Task {
            await notificationAuthorization()
            application.registerForRemoteNotifications()
        }
        
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    private func notificationAuthorization() async {
        do {
            try await  UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            UNUserNotificationCenter.current().delegate = self
        } catch {
            // TODO: Error Handling
            print(error.localizedDescription)
        }
    }
    
    private func googleAdMobService() {
        DispatchQueue.main.async {
            let googleMobileAds =  GADMobileAds.sharedInstance()
            // Initialize the Google Mobile Ads SDK.
            googleMobileAds.start(completionHandler: nil)
            googleMobileAds.requestConfiguration.testDeviceIdentifiers = [ "d9f08d9cab2fd3e9547c5309d09a0d19" ]
        }
    }
    
    
}


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        return [[.list, .banner, .sound]]
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
    }
}
