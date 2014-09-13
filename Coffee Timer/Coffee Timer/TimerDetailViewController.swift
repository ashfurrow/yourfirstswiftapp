//
//  TimerDetailViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-09-13.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

class TimerDetailViewController: UIViewController {
    
    @IBOutlet weak var durationLabel: UILabel!
    var timerModel: TimerModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = timerModel.coffeeName
        
        durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"
    }
}
