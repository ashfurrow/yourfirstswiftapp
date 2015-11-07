//
//  TimerDetailViewController.swift
//  Coffee Timer
//
//  Created by Ash Furrow on 2014-09-13.
//  Copyright (c) 2014 Ash Furrow. All rights reserved.
//

import UIKit

class TimerDetailViewController: UIViewController {

    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!

    var timerModel: TimerModel!

    weak var timer: NSTimer?
    var notification: UILocalNotification?
    var timeRemaining: NSInteger {
        guard let fireDate = notification?.fireDate else {
            return 0
        }

        let now = NSDate()
        return NSInteger(round(fireDate.timeIntervalSinceDate(now)))
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = timerModel.name

        countdownLabel.text = timerModel.durationText

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
        startStopButton.setTitle(NSLocalizedString("Stop", comment: "Stop button title"), forState: .Normal)
        startStopButton.setTitleColor(.redColor(), forState: .Normal)
        timer = NSTimer.scheduledTimerWithTimeInterval(1,
            target: self,
            selector: "timerFired",
            userInfo: nil,
            repeats: true)

        // Set up local notification
        let localNotification = UILocalNotification()
        localNotification.alertBody = NSLocalizedString("Timer Completed!", comment: "Timer completed alert body")
        localNotification.fireDate = NSDate().dateByAddingTimeInterval(NSTimeInterval(timerModel.duration))
        localNotification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        notification = localNotification

        updateTimer()
    }

    enum StopTimerReason {
        case Cancelled
        case Completed
    }

    func stopTimer(reason: StopTimerReason) {
        navigationItem.rightBarButtonItem?.enabled = true
        navigationItem.setHidesBackButton(false, animated: true)
        countdownLabel.text = timerModel.durationText
        startStopButton.setTitle(NSLocalizedString("Start", comment: "Start button title"), forState: .Normal)
        startStopButton.setTitleColor(.greenColor(), forState: .Normal)
        timer?.invalidate()

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
            countdownLabel.text = timerModel.durationText
        } else if keyPath == "name" {
            title = timerModel.name
        }
    }
}

extension TimerModel {
    var durationText: String {
        return String(format: "%d:%02d", duration / 60, duration % 60)
    }
}
