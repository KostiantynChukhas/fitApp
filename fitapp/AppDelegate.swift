//
//  AppDelegate.swift
//  fitapp
//

import UIKit
import FirebaseCore
import GoogleSignIn
import FBSDKCoreKit
import netfox
import IQKeyboardManagerSwift
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        IQKeyboardManager.shared.enable = true
        
        if Configuration.shared.environment.isNetfoxEnabled {
            NFX.sharedInstance().start()
        }
        
        FirebaseApp.configure()
        
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        if let window = window {
            appCoordinator = AppCoordinator(window: window)
            appCoordinator?.start()
        }
        
        SessionManager.shared.startManager()
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        print("🚸",url.scheme)
        if url.scheme == "com.googleusercontent.apps" {
                // Handle Google URL
                return GIDSignIn.sharedInstance().handle(url)
            } else if url.scheme == "fb" {
                // Handle Facebook URL
                return ApplicationDelegate.shared.application(app, open: url, options: options)
            }
        return false
    }
}


