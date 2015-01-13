//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-07-26.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    var name = ""
    var duration = 0
    var type = TimerType.Coffee

    enum TimerType {
        case Coffee
        case Tea
    }

    init(name: NSString, duration: Int, type: TimerType) {
        self.name = name
        self.duration = duration
        self.type = type
        super.init()
    }
    
    override var description: String {
        return "TimerModel(\(name))"
    }
}
