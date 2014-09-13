//
//  TimerModel.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-07-26.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import Foundation

class TimerModel: NSObject {
    var coffeeName = ""
    var duration = 0
    
    init(coffeeName: NSString, duration: Int) {
        self.coffeeName = coffeeName
        self.duration = duration
        super.init()
    }
    
    override var description: String {
        return "TimerModel(\(coffeeName))"
    }
}
