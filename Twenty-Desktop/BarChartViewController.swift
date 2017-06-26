//
//  BarChartViewController.swift
//  Twenty
//
//  Created by Rohin Tangirala on 6/25/17.
//  Copyright © 2017 Rohin Tangirala. All rights reserved.
//

import Cocoa
import Charts

class BarChartViewController: NSViewController {

    let defaults = UserDefaults.standard
    var days: [String]!
    //var initialViewController : ViewController = ViewController()
    
    @IBOutlet weak var barChartView: BarChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear() {
        //var mins: [Double] = []
        //var dates: [String] = []
        defaults.synchronize()
        if let _ : AnyObject = (defaults.object(forKey: "usageTimes") as AnyObject??)! {
            let mins = defaults.object(forKey: "usageTimes") as AnyObject?? as! [Double]
            if let _ : AnyObject = (defaults.object(forKey: "usageDates") as AnyObject??)! {
                let dates = defaults.object(forKey: "usageDates") as AnyObject?? as! [String]
                print(mins)
                print(dates)
                setChart(dataPoints: dates, values: mins)
                
            }
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        barChartView.clearValues()
        
        var dataEntries: [BarChartDataEntry] = Array()
        var counter = 0.0
        
        for i in 0..<dataPoints.count {
            counter += 1.0
            let dataEntry = BarChartDataEntry(x: counter, y: values[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Usage in minutes of each working period")
        let chartData = BarChartData()
        chartData.addDataSet(chartDataSet)
        barChartView.data = chartData
        self.barChartView.xAxis.drawGridLinesEnabled = false
        self.barChartView.legend.enabled = false
        self.barChartView.xAxis.drawLabelsEnabled = false
        self.barChartView.chartDescription?.text = "";
        
    }

    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
}
