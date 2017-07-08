//
//  TimerViewController.swift
//  Twenty-Desktop
//
//  Created by Rohin Tangirala on 6/22/17.
//  Copyright © 2017 Rohin Tangirala. All rights reserved.
//

import Cocoa

class TimerViewController: NSViewController {

    let originalCount : Int = 1200
    let defaults : UserDefaults = UserDefaults.standard

    var month : Int = 0
    var day : Int = 0
    var year : Int = 0
    var hour : Int = 0
    var minutes : Int = 0
    var count : Int = 1200
    var totalMin : Int = 1
    var currentDateTime : String = ""
    var minutesString : String = ""
    var startEndDateTime : String = ""
    var workTimer : Timer = Timer()
    var soundTimer : Timer = Timer()
    var breakTimer : Timer = Timer()
    var breakSoundTimer : Timer = Timer()
    var voiceTimer : Timer = Timer()
    var breakVoiceTimer : Timer = Timer()
    var date : Date = Date()
    var calendar : Calendar = Calendar.current
    var usageTimes : [Double] = []
    var usageDates : [String] = []
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var timeProgress: NSProgressIndicator!

    @IBAction func startPressed(_ sender: Any) {
        // Follow corresponding steps depending on current working period state
        if startButton.title == "Start Working Period" {
            startTasks()
            createMainTimers()
        } else {
            stopTasks()
            endAllTimers()
            usageTimes.append(Double(totalMin))
            defaults.set(usageTimes, forKey: "usageTimes")
            defaults.synchronize()
            usageDates.append(startEndDateTime)
            defaults.set(usageDates, forKey: "usageDates")
            defaults.synchronize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear() {
        usageTimes = []
        usageDates = []

        // Initialize data in UserDefaults
        if let usageTimesStored = defaults.object(forKey: "usageTimes") as AnyObject? {
            usageTimes = usageTimesStored as! [Double]
        }

        if let usageDatesStored = defaults.object(forKey: "usageDates") as AnyObject? {
            usageDates = usageDatesStored as! [String]
        }
    }

    // Handle various tasks (GUI, dates) when starting working period
    func startTasks() {
        startButton.title = "Stop Working Period"
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        year = calendar.component(.year, from: date) % 100
        hour = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)

        if (minutes < 10) {
            minutesString = "0" + String(minutes)
        } else {
            minutesString = String(minutes)
        }

        currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " "
            + String(hour) + ":" + minutesString
        startEndDateTime = currentDateTime
    }

    // Handle various tasks (GUI, dates) when stopping working period
    func stopTasks() {
        startButton.title = "Start Working Period"
        count = originalCount
        timeLabel.stringValue = "0 min"
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        year = calendar.component(.year, from: date) % 100
        hour = calendar.component(.hour, from: date)
        minutes = calendar.component(.minute, from: date)

        if (minutes < 10) {
            minutesString = "0" + String(minutes)
        } else {
            minutesString = String(minutes)
        }

        currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " "
            + String(hour) + ":" + minutesString
        startEndDateTime = startEndDateTime + " to " + currentDateTime
        timeProgress.doubleValue = 0
    }

    // Start main timers when starting working period
    func createMainTimers() {
        workTimer = Timer.scheduledTimer(timeInterval: 1, target: self,
            selector: #selector(TimerViewController.workUpdate), userInfo: nil, repeats: true)
        soundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self,
            selector: #selector(TimerViewController.endWorkTimer), userInfo: nil, repeats: false)
    }

    // Update GUI while workTimer is running
    func workUpdate() {
        if(count > 0) {
            count = count - 1
            timeProgress.doubleValue = 1-(Double(count)/Double(originalCount))
            timeLabel.stringValue = String(Int(round(Double(1000 * (count / 60))) / 1000) + 1) + " min"

            if (Double(count) / Double(60) == floor(Double(count) / Double(60))) {
                totalMin = totalMin + 1
            }
        }
    }

    // Update GUI while breakTimer is running
    func breakUpdate() {
        if(count > 0) {
            count = count - 1
            timeProgress.doubleValue = 1 - (Double(count) / Double(20))
            timeLabel.stringValue = String(count) + " seconds"
        }
    }

    // End and invalidate workTimer during working period
    func endWorkTimer() {
        showEndMainNotification()
        workTimer.invalidate()
        soundTimer.invalidate()
        timeLabel.stringValue = "0 min"
        count = 21
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self,
                                          selector: #selector(TimerViewController.breakUpdate), userInfo: nil, repeats: true)
        breakSoundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self,
                                               selector: #selector(TimerViewController.endBreakTimer), userInfo: nil, repeats: false)
    }

    // End and invalidate breakTimer
    func endBreakTimer() {
        showEndBreakNotification()
        breakTimer.invalidate()
        breakSoundTimer.invalidate()
        count = originalCount
        createMainTimers()
    }

    // End and invalidate all timers when stopping working period
    func endAllTimers() {
        workTimer.invalidate()
        soundTimer.invalidate()
        breakTimer.invalidate()
        breakSoundTimer.invalidate()
    }

    // Show local notification after 20 min working interval
    func showEndMainNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = "Time for a break"
        notification.subtitle = "Look away from your screen"
        notification.informativeText = "Look at something 20 ft away for 20 seconds."
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }

    // Show local notification after 20 sec break interval
    func showEndBreakNotification() -> Void {
        let notification = NSUserNotification()
        notification.title = "Break is over"
        notification.subtitle = "You may resume your work"
        notification.informativeText = "We'll let you know when it's break time again."
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
}
