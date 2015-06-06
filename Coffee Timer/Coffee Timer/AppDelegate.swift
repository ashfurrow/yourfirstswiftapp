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

    lazy var coreDataStack: CoreDataStack = {
        return CoreDataStack()
    }()

    func method (arg: String!) {
        print(arg)
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        println("Application has launched.")

        coreDataStack.loadDefaultDataIfFirstLaunch()

        window?.tintColor = UIColor(red:0.95, green:0.53, blue:0.27, alpha:1)

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        println("Application has resigned active.")

        let error = NSErrorPointer()
        if !coreDataStack.managedObjectContext.save(error) {
            println("Error saving context: \(error)")
        }
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("Application has entered background.")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        println("Application has entered foreground.")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("Application has become active.")
    }

    func applicationWillTerminate(application: UIApplication) {
        println("Application will terminate.")
    }

    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        println("Application received local notification.")

        let alertController = UIAlertController(title: notification.alertTitle, message: notification.alertBody, preferredStyle: .Alert)

        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)

        window!.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
    }
}

