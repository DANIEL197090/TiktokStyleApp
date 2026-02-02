//
//  AppDelegate.swift
//  TikTokApp
//
//  Created by Ifeanyi Mbata on 02/02/2026.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let tabBarController = MainTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
}
