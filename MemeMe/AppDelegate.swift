//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Abdullah on 10/12/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // Sent Memes shared model.
    var memes = [Meme]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}
