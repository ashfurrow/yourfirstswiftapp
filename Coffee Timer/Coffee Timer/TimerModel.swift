//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2015-06-06.
//  Copyright (c) 2015 Ash Furrow. All rights reserved.
//

import Foundation
import CoreData

class TimerModel: NSManagedObject {

    @objc enum TimerType: Int32 {
        case Coffee = 0
        case Tea
    }

    @NSManaged var name: String?
    @NSManaged var duration: Int32
    @NSManaged var type: TimerType
    @NSManaged var displayOrder: Int32

}
