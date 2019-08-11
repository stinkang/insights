//
//  DateSettingsPopoverViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/23/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

class DateSettingsPopoverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var selectionTable: UITableView!
    var dateState = 0
    var delegate: DateSettingsPopoverViewControllerDelegate!

    @IBOutlet weak var intervalTable: UITableView!
    
    override func viewDidLoad() {
        selectionTable.delegate = self
        selectionTable.dataSource = self
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let times = ["Daily", "Weekly", "Monthly"]
        let cell = tableView.dequeueReusableCell(withIdentifier: "timeSelection") as! timeSelectorTableViewCell
        let text = times[indexPath.row]
        cell.timeLabel.text = text
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        delegate.timeIntervalSelected(mode: indexPath.row)
    }
}

protocol DateSettingsPopoverViewControllerDelegate {
    func timeIntervalSelected(mode: Int)
}
