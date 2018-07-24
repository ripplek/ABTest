//
//  AppDelegate.swift
//  SoapVideo
//
//  Created by Carl Chen on 11/9/1396 AP.
//  Copyright © 1396 SoapVideo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
    var dependency: AppDependency!
    
    // MARK: - UI

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.dependency.configureAppearance()
        window = self.dependency.window
        return true
    }

}

