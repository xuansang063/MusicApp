//
//  AppDelegate.swift
//  MusicApp
//
//  Created by admin on 22/03/2020.
//  Copyright © 2020 SangNX. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setDefaultMaskType(.clear) // Don't allow user interaction
        SVProgressHUD.setMaximumDismissTimeInterval(1)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = MainTabbar()
        window?.setGradient(startColor: UIColor(displayP3Red: 133/255, green: 24/255, blue: 229/255, alpha: 1),
                            secondColor: UIColor(displayP3Red: 93/255, green: 153/255, blue: 238/255, alpha: 1))
        
        return true
    }
    
}
