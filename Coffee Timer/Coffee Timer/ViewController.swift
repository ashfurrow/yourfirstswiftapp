//
//  ViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-07-26.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("View is loaded.")
        
        view.backgroundColor = .orangeColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonWasPressed(sender: AnyObject) {
        println("Button was pressed.")
        
        // Get the current date and time
        let date = NSDate()
        
        // Update the label
        label.text = "Button pressed at \(date)"
    }
    @IBAction func sliderValueChanged(sender: AnyObject) {
        println("Slider value changed to \(slider.value)")
        
        // Update our progressView's progress to match 
        // the slider's value
        progressView.progress = slider.value
    }
}

