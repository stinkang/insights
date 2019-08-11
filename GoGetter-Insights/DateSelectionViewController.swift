//
//  DateSelectionTableViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/26/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

class DateSelectionViewController: UIViewController, DateTableViewControllerDelegate {
    
    var startDate: Date!
    var endDate: Date!
    var delegate: DateSelectionViewControllerDelegate!
    var vc: DateTableViewController!
    
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var yesterdayButton: UIButton!
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var lastWeekButton: UIButton!
    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var thisYearButton: UIButton!
    @IBOutlet weak var lastYearButton: UIButton!
    
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.tintColor = UIColor.init(hex: "0be182")
        todayButton.layer.cornerRadius = 12.75
        yesterdayButton.layer.cornerRadius = 12.75
        thisWeekButton.layer.cornerRadius = 12.75
        lastWeekButton.layer.cornerRadius = 12.75
        thisMonthButton.layer.cornerRadius = 12.75
        lastMonthButton.layer.cornerRadius = 12.75
        thisYearButton.layer.cornerRadius = 12.75
        lastYearButton.layer.cornerRadius = 12.75
        todayButton.layer.cornerRadius = 12.75
    }
    func isValidDateRange() -> Bool {
        if !(startDate.compare(endDate) == ComparisonResult.orderedAscending) {
            alert(self, title: "", message: "Please enter a valid date range.", callback: nil)
            return false
        }
        return true
    }
    
    @IBAction func save(_ sender: AnyObject) {
        if isValidDateRange() { delegate.setStartAndEndDate(startDate: self.startDate, endDate: self.endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // Handle user's request to hide the keyboard
    @IBAction func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    func startDateChanged(date: Date) {
        startDate = date
    }
    
    func endDateChanged(date: Date) {
        endDate = date
    }
    
    @IBAction func todayButtonSelected(_ sender: Any) {
        startDate = Date()
        endDate = Date()
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesterdayButtonSelected(_ sender: Any) {
        startDate = Date().oneDayAgo()
        endDate = Date().oneDayAgo()
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thisWeekButtonSelected(_ sender: Any) {
        startDate = Date().startOfWeek
        endDate = Date().endOfWeek
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lastWeekButtonSelected(_ sender: Any) {
        startDate = Date().startOfLastWeek
        endDate = Date().endOfLastWeek
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thisMonthSelected(_ sender: Any) {
        startDate = Date().startOfThisMonth
        endDate = Date().endOfThisMonth
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lastMonthSelected(_ sender: Any) {
        startDate = Date().startOfLastMonth
        endDate = Date().endOfLastMonth
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func thisYearSelected(_ sender: Any) {
        startDate = Date().startOfThisYear
        endDate = Date().endOfThisYear
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func lastYearSelected(_ sender: Any) {
        startDate = Date().startOfLastYear
        endDate = Date().endOfLastYear
        delegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // the segue to the embedded date selector table views
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "embedDateSelector"){
            let vc = segue.destination as! DateTableViewController
            vc.delegate = self
            vc.startDate = startDate
            vc.endDate = endDate
        }
    }
}

protocol DateSelectionViewControllerDelegate {
    func setStartAndEndDate(startDate: Date, endDate: Date)
}
