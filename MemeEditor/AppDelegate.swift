//
//  AppDelegate.swift
//  MemeEditor
//
//  Created by Mrunalini Gaddam on 8/10/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var memes = [Meme]()
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}
