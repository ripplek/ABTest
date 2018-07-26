//
//  CompositionRoot.swift
//  SoapVideo
//
//  Created by ripple_k on 2018/7/18.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

struct AppDependency {
    let window: UIWindow
    let configureAppearance: () -> Void
}

final class CompositionRoot {
    /// Builds a dependency graph and returns an entry view controller.
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()
        
        let networking = ABTestNetworking()
        let service = Service(networking: networking)
        let react = ViewReactor(service: service)
        let vc = ViewController(reactor: react)
        window.rootViewController = MainTabbarController(reactor: MainTabBarViewReactor(), shotListViewController: vc)
        return AppDependency(window: window,
                             configureAppearance: self.configureAppearance)
    }
    
    static func configureAppearance() {
        let navigationBarBackgroundImage = UIImage.resizable().color(.db_charcoal).image
        UINavigationBar.appearance().setBackgroundImage(navigationBarBackgroundImage, for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .db_slate
        UITabBar.appearance().tintColor = .db_charcoal
    }
}
