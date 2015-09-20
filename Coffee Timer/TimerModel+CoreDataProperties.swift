//
//  TimerModel+CoreDataProperties.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2015-09-20.
//  Copyright © 2015 Ash Furrow. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TimerModel {

    @objc enum TimerType: Int32 {
        case Coffee = 0
        case Tea
    }

    @NSManaged var name: String?
    @NSManaged var displayOrder: Int32
    @NSManaged var type: TimerType
    @NSManaged var duration: Int32

}
