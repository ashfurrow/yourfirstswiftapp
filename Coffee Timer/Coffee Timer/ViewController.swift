//
//  ViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-07-26.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var timerModel: TimerModel! {
        willSet(newModel) {
            print("About to change model to \(newModel)")
        }
        
        didSet {
            print("Set model to \(timerModel)")
            updateUserInterface()
        }
    }
                            
    override func viewDidLoad() {
        super.viewDidLoad()

        print("View is loaded.")
        title = "Root"
        
        setupModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    func setupModel() {
        self.timerModel = TimerModel(coffeeName: "Colombian Coffee", duration: 240)
    }
    
    func updateUserInterface() {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("Preparing for segue with identifier:\(segue.identifier)")
        
        if segue.identifier == "pushDetail" {
            let viewController = segue.destinationViewController as! TimerDetailViewController
            viewController.timerModel = timerModel
        } else if segue.identifier == "editDetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let viewController = navigationController.topViewController as! TimerEditViewController
            viewController.timerModel = timerModel
        }
    }
}

