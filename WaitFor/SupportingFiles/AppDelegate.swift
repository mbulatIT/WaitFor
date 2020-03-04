//
//  AppDelegate.swift
//  WaitFor
//
//  Created by Bulat, Maksim on 2/19/20.
//  Copyright © 2020 Bulat, Maksim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var tabBarController = UITabBarController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        showFirstController()
        window?.makeKeyAndVisible()
        return true
    }
    
    func showFirstController() {
        setupTabBarController()
        window?.rootViewController = tabBarController
    }
    
    private func setupTabBarController() {
        tabBarController.viewControllers?.removeAll()
        tabBarController.tabBar.barTintColor = UIColor(hex: 0xEBEA9D)
        let viewControllersInfo = viewControllers()
        var tabBarViewControllers = [UIViewController]()

        for index in 0...viewControllersInfo.count - 1 {
            let newViewController = viewControllersInfo[index]
            let tabbarItem = UITabBarItem(title: newViewController.title, image: nil, tag: 0)
            tabbarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -4.0)
            if let tabBarViewController = newViewController as? TabBarViewControllerProtocol {
                tabbarItem.title = tabBarViewController.tabBarItemTitle()
                tabbarItem.image = tabBarViewController.tabBarItemImages().0
                tabbarItem.selectedImage = tabBarViewController.tabBarItemImages().1
            }
            newViewController.tabBarItem = tabbarItem
            let navigationController = UINavigationController(rootViewController: newViewController)
            navigationController.navigationBar.barTintColor = .defaultYellow
            navigationController.navigationBar.tintColor = .white
            let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController.navigationBar.titleTextAttributes = textAttributes
            tabBarViewControllers.append(navigationController)
        }

        tabBarController.viewControllers = tabBarViewControllers
        tabBarController.tabBar.tintColor = .black
        tabBarController.tabBar.isTranslucent = false
    }
    
    private func viewControllers() -> [UIViewController] {
        var viewControllers = [UIViewController]()
        viewControllers.append(ViewControllerFactory.makeActiveEventViewController())
        viewControllers.append(ViewControllerFactory.makeEventsViewController())

        return viewControllers
    }
}

