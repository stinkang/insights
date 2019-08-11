//
//  EventReferralsTableViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/16/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit


// View Controller for eventReferralsTableView in ClientsViewController
class EventReferralsTableViewController: UIViewController, UITableViewDataSource, InsightsViewModelDelegate {
    
    func dataChanged() {
    }
    // these variables are set in ClientsViewController in its viewDidLoad()
    public var tableView: UITableView!
    public var viewModel: InsightsViewModel!
    public var eventReferralTableViewReferralNumberLabels: [String] = []
    public var eventReferralTableReferrerNames: [String] = []
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getEventReferralsPerClient().count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        let referrals = viewModel.getEventReferralsPerClient()
        for i in 0..<referrals.count {
            titles.append(referrals[i].0)
        }
        return titles
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               let cell = tableView.dequeueReusableCell(withIdentifier: "eventReferralCell") as! referralTableViewCell
        let num = eventReferralTableViewReferralNumberLabels[indexPath.section]
        let name = eventReferralTableReferrerNames[indexPath.section]
        cell.referrerLabel.text = name
        cell.referralNumberLabel.text = num
        cell.cellNumberLabel.text = String(indexPath.section + 1) + "."
        
        // So the cell doesn't stay highlighted
        cell.selectionStyle = .none
        return cell
    }
}
