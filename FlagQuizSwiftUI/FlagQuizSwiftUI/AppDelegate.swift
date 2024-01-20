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
            
            //TODO: - 출시할 때 지우기
#if DEBUG
            googleMobileAds.requestConfiguration.testDeviceIdentifiers = [ "92c9cb5011fb3415d6601fc50ae0a153" ]
#endif
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
