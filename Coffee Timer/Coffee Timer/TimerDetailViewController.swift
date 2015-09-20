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
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!

    var timerModel: TimerModel!

    var timer: NSTimer?
    var notification: UILocalNotification?
    var timeRemaining: NSInteger {
        if let fireDate = notification?.fireDate {
            let now = NSDate()

            
            return NSInteger(round(fireDate.timeIntervalSinceDate(now)))
        } else {
            return 0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = timerModel.name

        durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"

        countdownLabel.text = "Timer not started."

        timerModel.addObserver(self, forKeyPath: "duration", options: .New, context: nil)
        timerModel.addObserver(self, forKeyPath: "name", options: .New, context: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Request local notifications and set up local notification
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
    }

    @IBAction func buttonWasPressed(sender: AnyObject) {
        if let _ = timer {
            // Timer is running and button was pressed. Stop timer.
            stopTimer(.Cancelled)
        } else {
            // Timer is not running and button is pressed. Start timer.
            startTimer()
        }
    }

    func timerFired() {
        if timeRemaining > 0 {
            updateTimer()
        } else {
            stopTimer(.Completed)
        }
    }

    func updateTimer() {
        countdownLabel.text = String(format: "%d:%02d", timeRemaining / 60, timeRemaining % 60)
    }

    func startTimer() {
        navigationItem.rightBarButtonItem?.enabled = false
        navigationItem.setHidesBackButton(true, animated: true)
        startStopButton.setTitle("Stop", forState: .Normal)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "timerFired",
            userInfo: nil,
            repeats: true)

        // Set up local notification
        let localNotification = UILocalNotification()
        localNotification.alertBody = "Timer Completed!"
        localNotification.fireDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(timerModel.duration))
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        notification = localNotification

        updateTimer()
    }

    enum StopTimerReason {
        case Cancelled
        case Completed

        func message() -> String {
            switch self {
            case .Cancelled:
                return "Timer Cancelled."
            case .Completed:
                return "Timer Completed."
            }
        }
    }

    func stopTimer(reason: StopTimerReason) {
        navigationItem.rightBarButtonItem?.enabled = true
        navigationItem.setHidesBackButton(false, animated: true)
        countdownLabel.text = reason.message()
        startStopButton.setTitle("Start", forState: .Normal)
        timer?.invalidate()
        timer = nil

        if reason == .Cancelled {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
        notification = nil
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editDetail" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let editViewController = navigationController.topViewController as! TimerEditViewController

            editViewController.timerModel = timerModel
        }
    }

    deinit {
        timerModel.removeObserver(self, forKeyPath: "duration")
        timerModel.removeObserver(self, forKeyPath: "name")
    }

    override func observeValueForKeyPath(keyPath: String?,
        ofObject object: AnyObject?,
        change: [String : AnyObject]?,
        context: UnsafeMutablePointer<Void>) {

        if keyPath == "duration" {
            durationLabel.text = "\(timerModel.duration / 60) min \(timerModel.duration % 60) sec"
        } else if keyPath == "name" {
            title = timerModel.name
        }
    }
}
