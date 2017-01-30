//
//  AppDelegate.swift
//  IosDevTestSwift
//
//  Created by Olha Danylova on 29.01.17.
//  Copyright © 2017 Olha Danylova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    // Backendless application initialization.
    let APP_ID = "7272A465-A10C-B8FC-FFFC-EC6FAB58BA00"
    let SECRET_KEY = "5FED2132-3B26-38D4-FF91-8B08B265B600"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()    

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Backendless application initialization.
        backendless?.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        
        // Override point for customization after application launch.
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        splitViewController.delegate = self
        
        return true
    }


    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? ProductDetailsViewController else { return false }
        if topAsDetailController.product == nil {
            return true
        }
        return false
    }

}

