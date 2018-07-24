//
//  MainTabbarController.swift
//  SoapVideo
//
//  Created by ripple_k on 2018/7/19.
//  Copyright © 2018 SoapVideo. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa
import RxOptional
import ManualLayout

class MainTabbarController: UITabBarController, View {
    
    // MARK: Constants
    
    fileprivate struct Metric {
        static let tabBarHeight = 44.f
    }
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    
    init(
        reactor: MainTabBarViewReactor,
        shotListViewController: ViewController
        ) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [shotListViewController, UIViewController()]
            .map { viewController -> UINavigationController in
                let navigationController = UINavigationController(rootViewController: viewController)
                navigationController.tabBarItem.title = nil
                navigationController.tabBarItem.imageInsets.top = 5
                navigationController.tabBarItem.imageInsets.bottom = -5
                return navigationController
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Configuring
    
    func bind(reactor: MainTabBarViewReactor) {
        self.rx.didSelect
            .scan((nil, nil)) { state, viewController in
                return (state.1, viewController)
            }
            // if select the view controller first time or select the same view controller again
            .filter { state in state.0 == nil || state.0 === state.1 }
            .map { state in state.1 }
            .filterNil()
            .subscribe(onNext: { [weak self] viewController in
                self?.scrollToTop(viewController) // scroll to top
            })
            .disposed(by: self.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
        } else {
            self.tabBar.height = Metric.tabBarHeight
        }
        self.tabBar.bottom = self.view.height
    }
    
    func scrollToTop(_ viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            let topViewController = navigationController.topViewController
            let firstViewController = navigationController.viewControllers.first
            if let viewController = topViewController, topViewController === firstViewController {
                self.scrollToTop(viewController)
            }
            return
        }
        guard let scrollView = viewController.view.subviews.first as? UIScrollView else { return }
        scrollView.setContentOffset(.zero, animated: true)
    }
}
