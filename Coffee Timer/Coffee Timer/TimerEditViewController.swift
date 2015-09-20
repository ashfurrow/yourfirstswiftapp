//
//  TimerEditViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-09-13.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

class TimerEditViewController: UIViewController {
    
    var timerModel: TimerModel!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var minutesSlider: UISlider!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var secondsSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let numberOfMinutes = Int(timerModel.duration / 60)
        let numberOfSeconds = timerModel.duration % 60
        nameField.text = timerModel.coffeeName
        updateLabelsWithMinutes(numberOfMinutes, seconds: numberOfSeconds)
        minutesSlider.value = Float(numberOfMinutes)
        secondsSlider.value = Float(numberOfSeconds)
    }
    
    @IBAction func cancelWasPressed(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneWasPressed(sender: UIBarButtonItem) {
        timerModel.coffeeName = nameField.text ?? ""
        timerModel.duration = Int(minutesSlider.value) * 60 + Int(secondsSlider.value)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let numberOfMinutes = Int(minutesSlider.value)
        let numberOfSeconds = Int(secondsSlider.value)
        updateLabelsWithMinutes(numberOfMinutes, seconds: numberOfSeconds)
    }
    
    func updateLabelsWithMinutes(minutes: Int, seconds: Int) {
        func pluralize(value: Int, singular: String, plural: String) -> String {
            switch value {
            case 1:
                return "1 \(singular)"
            case let pluralValue:
                return "\(pluralValue) \(plural)"
            }
        }
        
        
        minutesLabel.text = pluralize(minutes, singular: "minute", plural: "minutes")
        secondsLabel.text = pluralize(seconds, singular: "second", plural: "seconds")
    }
}
