//
//  CircularProgressIndicator.swift
//  Twenty
//
//  Created by Rohin Tangirala on 7/15/19.
//  Copyright © 2019 Rohin Tangirala. All rights reserved.
//

import Cocoa

class CircularProgressIndicator: NSView {
  var rect: NSRect = NSRect()
  var progress: Double = 0
  var endAngle: CGFloat = -270

  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    self.needsDisplay = true
    rect = dirtyRect

    let circlePath = NSBezierPath()
    circlePath.appendOval(in: NSRect(x: 20, y: 20, width: 260, height: 260))
    NSColor.white.set()
    circlePath.lineWidth = 2
    circlePath.stroke()
    NSColor.black.set()
    circlePath.fill()


    let arcPath = NSBezierPath()
    arcPath.lineCapStyle = .round
    arcPath.lineWidth = 10
    NSColor(calibratedRed: 0.78, green: 0.09, blue: 0.87, alpha: 1.0).set()
    arcPath.appendArc(withCenter: NSMakePoint(150, 150), radius: 130, startAngle: -270, endAngle: endAngle, clockwise: true)
    arcPath.stroke()

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .center
  }

  func updateProgress(newProgress: Double) {
    progress = newProgress
    endAngle = calculateAngle(progressValue: progress)
    setNeedsDisplay(rect)
  }

  func calculateAngle(progressValue : Double) -> CGFloat {
    return CGFloat(progressValue*(-360) - 270)
  }
}

