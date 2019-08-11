//
//  InsightsTabViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 6/20/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import UIKit
import Charts
import MXSegmentedPager
import MapKit
import UICountingLabel

class InsightsTabViewController: MXSegmentedPagerController, InsightsViewModelDelegate, InsightsTabViewControllerDelegate {
    
    // These two methods as InsightsTabViewControllerDelegate
    func setStartAndEndDate(startDate: Date, endDate: Date) {
        if leadsPageLoaded {
            revenueDelegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
            leadsDelegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        }
        if clientsPageLoaded {
            clientsDelegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        }
        if schedulingPageLoaded {
            schedulingDelegate.setStartAndEndDate(startDate: startDate, endDate: endDate)
        }
    }
    
    
    func dateStateChanged(dateState: Int) {
        if leadsPageLoaded {
            revenueDelegate.dateStateChanged(dateState: dateState)
            leadsDelegate.dateStateChanged(dateState: dateState)
        }
        if clientsPageLoaded {
            clientsDelegate.dateStateChanged(dateState: dateState)
        }
        if schedulingPageLoaded {
            schedulingDelegate.dateStateChanged(dateState: dateState)
        }
    }
    
    //Day, Week, Month
    var dateState: Int!
    
    //So that it doesn't call the delegate function before it has a delegate (set to true when loading respective viewController segues
    var leadsPageLoaded = false
    var clientsPageLoaded = false
    var schedulingPageLoaded = false
    //Delegates for each of the pages so that this view controller can call their dateState() methods, which change the graphs in each respective page according to the dateState
    var summaryDelegate: SummaryViewControllerDelegate!
    var revenueDelegate: RevenueViewControllerDelegate!
    var leadsDelegate: LeadsViewControllerDelegate!
    var clientsDelegate: ClientsViewControllerDelegate!
    var schedulingDelegate: SchedulingViewControllerDelegate!
    func dataChanged() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedPager.backgroundColor = .white

        
        // Segmented Control customization
        segmentedPager.segmentedControlPosition = MXSegmentedControlPosition.top
        segmentedPager.segmentedControl.selectionIndicatorLocation = .down
        segmentedPager.segmentedControl.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1450980392, blue: 0.2549019608, alpha: 1)
        segmentedPager.segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.roundBox
        segmentedPager.segmentedControl.selectionIndicatorHeight = -1.0
        segmentedPager.segmentedControl.selectionIndicatorColor = #colorLiteral(red: 0.0431372549, green: 0.8823529412, blue: 0.5098039216, alpha: 1)
        segmentedPager.segmentedControl.selectedTitleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
        segmentedPager.segmentedControl.titleTextAttributes = [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.631372549, green: 0.631372549, blue: 0.631372549, alpha: 1), NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)]
        segmentedPager.backgroundColor = #colorLiteral(red: 0.1098039216, green: 0.1450980392, blue: 0.2549019608, alpha: 1)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func segmentedPager(_ segmentedPager: MXSegmentedPager, titleForSectionAt index: Int) -> String {
        return ["Summary", "Revenue", "Leads", "Clients", "Scheduling", "Goals"][index]
    }
    
    override func heightForSegmentedControl(in segmentedPager: MXSegmentedPager) -> CGFloat {
        return 28
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "mx_page_0") {
            let vc = segue.destination as! SummaryViewController
            summaryDelegate = vc
            vc.dateState = dateState
        }
        if (segue.identifier == "mx_page_1") {
            let vc = segue.destination as! RevenueViewController
            revenueDelegate = vc
            vc.dateState = dateState
        }
        if (segue.identifier == "mx_page_2") {
            leadsPageLoaded = true
            let vc = segue.destination as! LeadsViewController
            leadsDelegate = vc
           vc.dateState = dateState
        }
        if (segue.identifier == "mx_page_3") {
            clientsPageLoaded = true
            let vc = segue.destination as! ClientsViewController
            clientsDelegate = vc
            vc.dateState = dateState
        }
        if (segue.identifier == "mx_page_4") {
            schedulingPageLoaded = true
            let vc = segue.destination as! SchedulingViewController
            schedulingDelegate = vc
            vc.dateState = dateState
        }
//        if (segue.identifier == "mx_page_5") {
//            let vc = segue.destination as! GoalsViewController
//            vc.dateState = dateState
//        }
    }
}
protocol InsightsTabViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}

protocol SummaryViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}
protocol RevenueViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}
protocol ClientsViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}

protocol LeadsViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}

protocol SchedulingViewControllerDelegate {
    func dateStateChanged(dateState: Int)
    func setStartAndEndDate(startDate: Date, endDate: Date)
}
