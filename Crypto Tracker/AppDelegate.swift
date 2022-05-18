//
//  AppDelegate.swift
//  Crypto Tracker
//
//  Created by Shreya Bhatia on 12/05/22.
//

import UIKit
import LocalAuthentication

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) && UserDefaults.standard.bool(forKey: "secure") {
            // Auth VC
            let authVC = AuthViewController()
            window?.rootViewController = authVC
        } else {
            let cryptoTableVC = CryptoTableViewController()
            let navController = UINavigationController(rootViewController: cryptoTableVC)
            window?.rootViewController = navController
        }
        
        
        
        
        
        
        window?.makeKeyAndVisible()
        return true
    }


}

