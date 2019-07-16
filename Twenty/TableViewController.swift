//
//  TableViewController.swift
//  Twenty
//
//  Created by Rohin Tangirala on 7/15/19.
//  Copyright © 2019 Rohin Tangirala. All rights reserved.
//

import Cocoa

class TableViewController: NSViewController {
  let defaults: UserDefaults = UserDefaults.standard

  var gDates: [String] = []
  var gMins: [Double] = []
  var exportString: String = ""

  @IBOutlet weak var tableView: NSTableView!

  // Confirm whether user wants to clear all data
  @IBAction func clearPressed(_ sender: Any) {
    let answer = dialogOKCancel(question: "Are you sure you want to clear all data?", text: "This action cannot be undone.")

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
    alert.alertStyle = NSAlert.Style.warning
    alert.addButton(withTitle: "Cancel")
    alert.addButton(withTitle: "Clear")
    let res = alert.runModal()

    if res == NSApplication.ModalResponse.alertFirstButtonReturn {
      return false
    }

    return true
  }

  @IBAction func exportData(_ sender: Any) {
    let text = exportString + "\n\nSent from Twenty for MacOS"

    let sharingPicker = NSSharingServicePicker(items: [text])

    sharingPicker.delegate = self
    sharingPicker.show(relativeTo: NSZeroRect, of: sender as! NSView, preferredEdge: .minY)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do view setup here.
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
      exportString.append(text + "\t")
    } else if tableColumn == tableView.tableColumns[1] {
      text = String(Int(self.gMins[row])) + (self.gMins[row] > 1.0 ? " minutes" : " minute")
      cellIdentifier = CellIdentifiers.TimeCell
      exportString.append(text + "\n")
    }

    if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) 
      as? NSTableCellView {
      cell.textField?.stringValue = text
      return cell
    }

    return nil
  }
}

extension TableViewController: NSSharingServicePickerDelegate {
  func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, sharingServicesForItems items: [Any], 
    proposedSharingServices proposedServices: [NSSharingService]) -> [NSSharingService] {
    var share = proposedServices
    share[0].subject = "My Usage Data from Twenty"
    return share
  }
}

