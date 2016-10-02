//
//  AppDelegate.swift
//  myMoney
//
//  Created by Мануэль on 01.06.16.
//  Copyright © 2016 AuroraInterplay. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var managedContext = DataManager.sharedInstance().context
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let tabBar = window!.rootViewController as! UITabBarController
        
        let navController = tabBar.viewControllers?[1] as! UINavigationController
        let mainScreen    = tabBar.viewControllers?[0] as! MainScreenViewController
        let countsScreen  = tabBar.viewControllers?[2] as! AccountManageViewController
        let catalogScreen = tabBar.viewControllers?[3] as! ArticleManageViewController
        
        let documents     = navController.viewControllers.first as! DocumentJournalCheckTableViewController
        
        
        countsScreen.managedContext  = managedContext        
        documents.managedContext     = managedContext
        mainScreen.managedContext    = managedContext
        catalogScreen.managedContext = managedContext
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        try! DataManager.sharedInstance().saveContext()
    }
    
      
}

