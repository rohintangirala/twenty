//
//  TableViewController.swift
//  Twenty
//
//  Created by Rohin Tangirala on 6/23/17.
//  Copyright © 2017 Rohin Tangirala. All rights reserved.
//

import Cocoa

class TableViewController: NSViewController {
    let defaults : UserDefaults = UserDefaults.standard

    var gDates: [String] = []
    var gMins : [Double] = []
     
    @IBOutlet weak var tableView: NSTableView!
     
    // Confirm whether user wants to clear all data
    @IBAction func clearPressed(_ sender: Any) {
        let answer = dialogOKCancel(question: "Are you sure you want to clear all data?",
            text: "This action cannot be undone.")

        if answer {
            gDates = []
            gMins = []

            if Bundle.main.bundleIdentifier != nil {
                    defaults.set(gMins, forKey: "usageTimes")
                    defaults.synchronize()
                    defaults.set(gDates, forKey: "usageDates")
                    defaults.synchronize()
                    defaults.synchronize()
            }

            tableView.reloadData()
        }
    }

    // Create OK/Cancel dialog box for clearing data
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert: NSAlert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = NSAlertStyle.warning
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Clear")
        let res = alert.runModal()

        if res == NSAlertFirstButtonReturn {
            return false
        }
          
        return true
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
          
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
     
    }
     
    override func viewDidAppear() {
        // Get data from UserDefaults
        if let _ : AnyObject = (defaults.object(forKey: "usageTimes") as AnyObject??)! {
            let mins = defaults.object(forKey: "usageTimes") as AnyObject?? as! [Double]
            gMins = mins

            if let _ : AnyObject = (defaults.object(forKey: "usageDates") as AnyObject??)! {
                let dates = defaults.object(forKey: "usageDates") as AnyObject?? as! [String]
                gDates = dates
            }
        }
          
        tableView.reloadData()
    }
}

extension TableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.gDates.count
    }
}

extension TableViewController: NSTableViewDelegate {
    fileprivate enum CellIdentifiers {
        static let DateCell = "DateCellID"
        static let TimeCell = "TimeCellID"
    }

    // Initialize table view with data
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
          
        if tableColumn == tableView.tableColumns[0] {
            text = self.gDates[row]
            cellIdentifier = CellIdentifiers.DateCell
        } else if tableColumn == tableView.tableColumns[1] {
            text = String(Int(self.gMins[row])) + (self.gMins[row] > 1.0 ? " minutes" : " minute")
            cellIdentifier = CellIdentifiers.TimeCell
        }
          
        if let cell = tableView.make(withIdentifier: cellIdentifier, owner: nil) as? NSTableCellView {
            cell.textField?.stringValue = text
            return cell
        }

        return nil
    }
}
