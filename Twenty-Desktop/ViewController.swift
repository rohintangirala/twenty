//
//  ViewController.swift
//  Twenty-Desktop
//
//  Created by Rohin Tangirala on 6/22/17.
//  Copyright © 2017 Rohin Tangirala. All rights reserved.
//

import Cocoa
import AVFoundation

class ViewController: NSViewController {

    var workTimer = Timer()
    var soundTimer = Timer()
    var breakTimer = Timer()
    var breakSoundTimer = Timer()
    var voiceTimer = Timer()
    var breakVoiceTimer = Timer()
    var count = 10
    let originalCount = 10
    var totalMin = 1
    let defaults = UserDefaults.standard
    var usageTimes = [Double]()
    var date = Date()
    var calendar = Calendar.current
    var currentDateTime = String()
    var month = Int()
    var day = Int()
    var year = Int()
    var hour = Int()
    var minutes = Int()
    var minutesString = String()
    var usageDates = [String]()
    var startEndDateTime = String()
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var timeProgress: NSProgressIndicator!
    
    @IBAction func startPressed(_ sender: Any) {
        if startButton.title == "Start Working Period" {
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
            
            currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + minutesString
            
            startEndDateTime = currentDateTime
            
            createMainTimers()
        } else {
            startButton.title = "Start Working Period"
            workTimer.invalidate()
            soundTimer.invalidate()
            breakTimer.invalidate()
            breakSoundTimer.invalidate()
            count = 10
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
            
            currentDateTime = String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + minutesString
            
            startEndDateTime = startEndDateTime + " to " + currentDateTime
            timeProgress.doubleValue = 0
            usageTimes.append(Double(totalMin))
            defaults.set(usageTimes, forKey: "usageTimes")
            defaults.synchronize()
            usageDates.append(startEndDateTime)
            defaults.set(usageDates, forKey: "usageDates")
            defaults.synchronize()

        }
    }
    
    func createMainTimers() {
        workTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
            
        soundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector: #selector(ViewController.endTimer), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // tell the controller's view to use a CALayer as its backing store
        //view.wantsLayer = true
        // change the background color of the layer
        //view.layer?.backgroundColor = CGColor(red: 0.15, green: 0.13, blue: 0.13, alpha: 1.0)
        
    }
    
    override func viewDidAppear() {
        usageTimes = []
        usageDates = []
        
        if let usageTimesStored = defaults.object(forKey: "usageTimes") as AnyObject? {
            usageTimes = usageTimesStored as! [Double]
        }
        if let usageDatesStored = defaults.object(forKey: "usageDates") as AnyObject? {
            usageDates = usageDatesStored as! [String]
        }
    }
    
    func showEndMainNotification() -> Void {
        
        let notification = NSUserNotification()
        
        // All these values are optional
        notification.title = "Time for a break"
        notification.subtitle = "Look away from your screen"
        notification.informativeText = "Look at something 20 ft away for 20 seconds."
        //notification.contentImage = nil
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    func showEndBreakNotification() -> Void {
        
        let notification = NSUserNotification()
        
        // All these values are optional
        notification.title = "Break is over"
        notification.subtitle = "You may resume your work"
        notification.informativeText = "We'll let you know when it's break time again."
        //notification.contentImage = nil
        notification.soundName = NSUserNotificationDefaultSoundName
        
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    


    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func update() {
        
        if(count > 0) {
            count = count - 1
            timeProgress.doubleValue = 1-(Double(count)/Double(originalCount))
            timeLabel.stringValue = String(Int(round(Double(1000*(count/60)))/1000)+1) + " min"
            if (Double(count)/Double(60) == floor(Double(count)/Double(60))) {
                totalMin = totalMin + 1
            }
        }
    }
    
    func breakUpdate() {
        if(count > 0) {
            count = count - 1
            timeProgress.doubleValue = 1-(Double(count)/Double(20))
            
            timeLabel.stringValue = String(count) + " seconds"
        }
    }
    
    func endTimer() {
        showEndMainNotification()
        /*if (voiceSwitch.isOn) {
            voiceTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.voice), userInfo: nil, repeats: false)
        }*/
        
        
        workTimer.invalidate()
        soundTimer.invalidate()
        
        timeLabel.stringValue = "0 min"
        count = 21
        breakTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.breakUpdate), userInfo: nil, repeats: true)
        breakSoundTimer = Timer.scheduledTimer(timeInterval: TimeInterval(count), target: self, selector: #selector(ViewController.endBreakTimer), userInfo: nil, repeats: false)
    }
    
    func endBreakTimer() {
        showEndBreakNotification()
        
        /*if (voiceSwitch.isOn) {
            breakVoiceTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.breakVoice), userInfo: nil, repeats: false)
        }*/
        breakTimer.invalidate()
        breakSoundTimer.invalidate()
        count = 10
        
        
        createMainTimers()
    }
    

    

}

