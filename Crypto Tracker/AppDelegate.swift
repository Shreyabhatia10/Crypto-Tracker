//
//  AppDelegate.swift
//  Crypto Tracker
//
//  Created by Shreya Bhatia on 12/05/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let cryptoTableVC = CryptoTableViewController()
        let navController = UINavigationController(rootViewController: cryptoTableVC)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }


}

