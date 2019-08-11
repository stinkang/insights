//
//  DatePickerViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/23/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

// Overlaid on top of the segmented control. Controls date picker and toggles DateSelectionViewController when the date button is tapped.
class DatePickerViewController: UIViewController, UIPopoverPresentationControllerDelegate, DateSettingsPopoverViewControllerDelegate, DateSelectionViewControllerDelegate {
    
    //as DateSelectionViewControllerDelegate
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
        insightsTabViewControllerDelegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        setDateButtonTitle()
    }
    
    
    //as DateSettingsPopoverViewControllerDelegate
    func timeIntervalSelected(mode: Int) {
        self.dateState = mode
        let times = ["Daily", "Weekly", "Monthly"]
        settingsButton.setTitle(times[mode], for: .normal)
        insightsTabViewControllerDelegate.dateStateChanged(dateState: self.dateState)
    }
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    
    let formatter = DateFormatter()
    var dateState = 0
    var startDate: Date!
    var endDate: Date!
    var dateSettingsVC = DateSettingsPopoverViewController()
    var insightsTabViewControllerDelegate: InsightsTabViewControllerDelegate!
    
    override func viewDidLoad() {
        let origImage = UIImage(named: "ArrowBack")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(tintedImage, for: .normal)
        backButton.tintColor = .white
        
        let origImage1 = UIImage(named: "ArrowForward")
        let tintedImage1 = origImage1?.withRenderingMode(.alwaysTemplate)
        forwardButton.setImage(tintedImage1, for: .normal)
        forwardButton.tintColor = .white
        
        dateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        dateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        settingsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8901960784, green: 0.9490196078, blue: 0.9921568627, alpha: 1)
        //UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.8901960784, green: 0.9490196078, blue: 0.9921568627, alpha: 1)
        //UINavigationBar.appearance().tintColor = #colorLiteral(red: 0.8901960784, green: 0.9490196078, blue: 0.9921568627, alpha: 1)
        UINavigationBar.appearance().shadowImage = UIImage.imageWithColor(#colorLiteral(red: 0.8901960784, green: 0.9490196078, blue: 0.9921568627, alpha: 1))
        UINavigationBar.appearance().titleTextAttributes =
        [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        formatter.dateFormat = "MM/dd/yy"
        startDate = Date().getStartingDate(fromMode: dateState)
        endDate = Date()
        setDateButtonTitle()
    }
    
    func setDateButtonTitle() {
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        dateButton.setTitle(start + " - " + end, for: .normal)
    }
    
    //move the date back according to the dateState
    @IBAction func backArrowWasPressed(_ sender: Any) {
        let start = formatter.string(from: startDate.getStartingDate(fromMode: dateState))
        let end = formatter.string(from: endDate.getStartingDate(fromMode: dateState))
        dateButton.setTitle(start + " - " + end, for: .normal)
        startDate = formatter.date(from: start)
        endDate = formatter.date(from: end)
    }
    // move the date forward according to the dateState
    @IBAction func forwardArrowWasPressed(_ sender: Any) {
        let start = formatter.string(from: startDate.getEndingDate(fromMode: dateState))
        let end = formatter.string(from: endDate.getEndingDate(fromMode: dateState))
        dateButton.setTitle(start + " - " + end, for: .normal)
        startDate = formatter.date(from: start)
        endDate = formatter.date(from: end)
    }
    
    // toggle the popover
    @IBAction func settingsWasPressed(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "settingsPopover") as! DateSettingsPopoverViewController
        vc.preferredContentSize = CGSize(width: 90, height: 130)
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.sourceView = sender
        popOver?.sourceRect = sender.bounds
        popOver?.permittedArrowDirections = UIPopoverArrowDirection.up;

        self.present(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // the segue to the DateSelectionViewController
        if(segue.identifier == "toggleDatePicker") {
            let vc = segue.destination as! DateSelectionViewController
            vc.delegate = self
            vc.startDate = self.startDate
            vc.endDate = self.endDate
        }
        // the segue to the segmented control
        if (segue.identifier == "segmentedControlSegue") {
            let vc = segue.destination as! InsightsTabViewController
            insightsTabViewControllerDelegate = vc
            vc.dateState = dateState
        }
    }
}


