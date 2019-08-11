//
//  DateTableViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/27/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

class DateTableViewController: UITableViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var delegate: DateTableViewControllerDelegate!
    var startDate: Date!
    var endDate: Date!
    override func viewDidLoad() {
        startDatePicker.setDate(startDate, animated: false)
        startDatePicker.setValue(#colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1), forKey: "textColor")
        startDatePicker.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1450980392, blue: 0.2549019608, alpha: 1)
        endDatePicker.setDate(endDate, animated: false)
        endDatePicker.setValue(#colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1), forKey: "textColor")
        endDatePicker.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1450980392, blue: 0.2549019608, alpha: 1)
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        delegate.startDateChanged(date: startDatePicker.date)
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        delegate.endDateChanged(date: endDatePicker.date)
    }
}

protocol DateTableViewControllerDelegate {
    func startDateChanged(date: Date)
    func endDateChanged(date: Date)
}
