//
//  AppDelegate.swift
//  FlagQuizSwiftUI
//
//  Created by Martin on 12/12/23.
//

import UIKit

import FirebaseCore
import GoogleSignIn
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        DispatchQueue.main.async {
            let googleMobileAds =  GADMobileAds.sharedInstance()
            // Initialize the Google Mobile Ads SDK.
            googleMobileAds.start(completionHandler: nil)
            googleMobileAds.requestConfiguration.testDeviceIdentifiers = [ "d9f08d9cab2fd3e9547c5309d09a0d19" ]
        }
        
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
