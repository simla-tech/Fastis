//
//  AppDelegate.swift
//  Example
//
//  Created by Ilya Kharlamov on 14.04.2020.
//  Copyright © 2020 DIGITAL RETAIL TECHNOLOGIES, S.L. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let vc = ViewController()
        let navVc = UINavigationController(rootViewController: vc)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navVc
        self.window?.makeKeyAndVisible()
        return true
    }

}
