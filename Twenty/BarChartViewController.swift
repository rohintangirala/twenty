//
//  BarChartViewController.swift
//  Twenty
//
//  Created by Rohin Tangirala on 7/15/19.
//  Copyright © 2019 Rohin Tangirala. All rights reserved.
//

import Cocoa
import Charts

class BarChartViewController: NSViewController {
    let defaults: UserDefaults = UserDefaults.standard
    var days: [String] = []

    @IBOutlet weak var barChartView: BarChartView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do view setup here.
        self.view.wantsLayer = true
    }

    override func viewDidAppear() {
        defaults.synchronize()

        // Get data from UserDefaults
        if let _ : AnyObject = (defaults.object(forKey: "usageTimes") as AnyObject??)! {
            let mins = defaults.object(forKey: "usageTimes") as AnyObject?? as! [Double]

            if let _ : AnyObject = (defaults.object(forKey: "usageDates") as AnyObject??)! {
                let dates = defaults.object(forKey: "usageDates") as AnyObject?? as! [String]
                setChart(dataPoints: dates, values: mins)
            }
        }
    }

    // Create bar graph and initialize with values
    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.clearValues()
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0

        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: counter, y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Usage in minutes of each working period")
        chartDataSet.setColors(
            NSUIColor(calibratedRed: 0.6, green: 0, blue: 0.69, alpha: 1.0),
            NSUIColor(calibratedRed: 1.0, green: 0, blue: 0.38, alpha: 1.0),
            NSUIColor(calibratedRed: 0.22, green: 0, blue: 0.98, alpha: 1.0)
        )

        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        chartDataSet.drawValuesEnabled = false
        self.barChartView.data = chartData
        self.barChartView.leftAxis.labelTextColor = NSUIColor.white
        self.barChartView.rightAxis.drawLabelsEnabled = false
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.drawGridLinesEnabled = false
        self.barChartView.rightAxis.drawGridLinesEnabled = false
        self.barChartView.leftAxis.axisMinimum = 0.0
        self.barChartView.xAxis.drawAxisLineEnabled = false
        self.barChartView.leftAxis.drawAxisLineEnabled = false
        self.barChartView.rightAxis.drawAxisLineEnabled = false
        self.barChartView.legend.enabled = false
        self.barChartView.xAxis.drawLabelsEnabled = false
        self.barChartView.chartDescription?.text = "";
        self.barChartView.noDataTextColor = NSUIColor.white
    }
}
