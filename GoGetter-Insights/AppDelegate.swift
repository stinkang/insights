//
//  AppDelegate.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/20/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Nav Bar Override
        let navBarFontSize: CGFloat = 18.0
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        UINavigationBar.appearance().isOpaque = true
        UINavigationBar.appearance().barStyle = UIBarStyle.black
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
        
        UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0))
        UINavigationBar.appearance().tintColor = UIColor.white
        
        let customFont = UIFont.systemFont(ofSize: navBarFontSize, weight: .heavy)
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: customFont, NSAttributedStringKey.foregroundColor: UIColor.white]
        let barButtonItemFont = UIFont.systemFont(ofSize: 16, weight: .regular)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: barButtonItemFont], for: UIControlState())
        
        UITabBar.appearance().tintColor = UIColor(red: 11/255.0, green: 225/255.0, blue: 130/255.0, alpha: 1.0)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

