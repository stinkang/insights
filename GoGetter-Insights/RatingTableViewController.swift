//
//  RatingTableViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/16/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

// View Controller for ratingTableView in ClientsViewController
class RatingTableViewController: UIViewController, UITableViewDataSource, InsightsViewModelDelegate {
    
    //these variables are set in ClientsViewController in its viewDidLoad()
    public var tableView: UITableView!
    public var viewModel: InsightsViewModel!
    public var ratingLabels: [String] = []
    public var names: [String] = []
    public var numRatings: [Double] = []
    func dataChanged() {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getRatingsPerClient().count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var titles = [String]()
        let ratings = viewModel.getRatingsPerClient()
        for i in 0..<ratings.count {
            titles.append(ratings[i].0)
        }
        return titles
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as! RatingTableViewCell
        let num = ratingLabels[indexPath.section]
        let name = names[indexPath.section]
        let ratingNum = self.numRatings[indexPath.section]
        cell.referrerLabel.text = name
        cell.referralNumberLabel.text = num
        cell.numRatingsLabel.text = String(ratingNum)
        cell.cellNumberLabel.text = String(indexPath.section + 1) + "."
        return cell
    }
    
    
}
