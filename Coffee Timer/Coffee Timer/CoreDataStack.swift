//
//  AppDelegate+CoreData.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2015-06-06.
//  Copyright (c) 2015 Ash Furrow. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext()
        moc.persistentStoreCoordinator = self.persistentStoreCoordinator
        return moc
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let storeURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("CoffeeTimer.sqlite")

        let errorPointer = NSErrorPointer()

        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil)
        } catch {
            print("Unresolved error adding persistent store: \(error)")
        }

        return coordinator
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = NSBundle.mainBundle().URLForResource("CoffeeTimer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    func loadDefaultDataIfFirstLaunch() {
        let key = "hasLaunchedBefore"
        let launchedBefore = NSUserDefaults.standardUserDefaults().boolForKey(key)

        if launchedBefore == false {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: key)

            for i in 0..<5 {
                let model = NSEntityDescription.insertNewObjectForEntityForName("TimerModel", inManagedObjectContext: managedObjectContext) as! TimerModel

                switch i {
                case 0:
                    model.name = NSLocalizedString("Colombian", comment: "Columbian coffee name")
                    model.duration = 240
                    model.type = .Coffee
                case 1:
                    model.name = NSLocalizedString("Mexican", comment: "Mexian coffee name")
                    model.duration = 200
                    model.type = .Coffee
                case 2:
                    model.name = NSLocalizedString("Green Tea", comment: "Green tea name")
                    model.duration = 400
                    model.type = .Tea
                case 3:
                    model.name = NSLocalizedString("Oolong", comment: "Oolong tea name")
                    model.duration = 400
                    model.type = .Tea
                default: // case 4:
                    model.name = NSLocalizedString("Rooibos", comment: "Rooibos tea name")
                    model.duration = 480
                    model.type = .Tea
                }

                model.displayOrder = Int32(i)
            }
        }

        save()
    }

    func save() {
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    private func applicationDocumentsDirectory() -> NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!
    }
}
