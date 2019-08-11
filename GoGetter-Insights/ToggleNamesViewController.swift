//
//  ToggleNamesViewController.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/13/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

// Class which is basically a TableViewController; controls a table which toggles names of people that a client has referred
// This view controller is presented when someone taps a cell in the referrals table in ClientsViewController
class ToggleNamesViewController: UITableViewController {
    @IBOutlet weak var navItem: UINavigationItem!
    
    var names = [String]()
    var referrer: String!
    
    override func viewDidLoad() {
        tableView.tableFooterView = UIView()
        UIApplication.statusBarBackgroundColor = UIColor(red: 0/255.0, green: 188/255.0, blue: 212/255.0, alpha: 1.0)
        // Changes the nav bar title to "[person's name]'s Referrals"
        navItem.title = referrer + "Referrals"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toggleNamesCell", for: indexPath)
        let text = names[indexPath.row]
        cell.textLabel?.text = text
        cell.textLabel?.textColor = .white
        return cell
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
