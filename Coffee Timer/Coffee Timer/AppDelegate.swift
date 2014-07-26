//
//  AppDelegate.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-07-26.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func method (arg: String!) {
        print(arg)
    }

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        println("Application has launched.")
        return true
    }

    func applicationWillResignActive(application: UIApplication!) {
        println("Application has resigned active.")
    }

    func applicationDidEnterBackground(application: UIApplication!) {
        println("Application has entered background.")
    }

    func applicationWillEnterForeground(application: UIApplication!) {
        println("Application has entered foreground.")
    }

    func applicationDidBecomeActive(application: UIApplication!) {
        println("Application has become active.")
    }

    func applicationWillTerminate(application: UIApplication!) {
        println("Application will terminate.")
    }


}

