//
//  AppDelegate.swift
//  Twenty
//
//  Created by Rohin Tangirala on 7/14/19.
//  Copyright © 2019 Rohin Tangirala. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {
  func applicationDidFinishLaunching(_ aNotification: Notification) {
      // Insert code here to initialize your application
      NSUserNotificationCenter.default.delegate = self
  }

  func applicationWillTerminate(_ aNotification: Notification) {
      // Insert code here to tear down your application
  }

  func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
    return true
  }

  func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}

