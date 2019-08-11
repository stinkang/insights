//
//  ToggleEventsViewControllers.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 8/8/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

class ToggleEventViewController: UIViewController {
    
    var event: Event!
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventRevenueLabel: UILabel!
    @IBOutlet weak var eventAttendeesLabel: UILabel!
    @IBOutlet weak var eventLengthLabel: UILabel!
    
    override func viewDidLoad() {
        eventNameLabel.text = event.name
        eventRevenueLabel.text = "$" + String(event.revenue)
        eventAttendeesLabel.text = String(event.attendees.count)
        eventLengthLabel.text = String(event.minutes)
    }
    @IBAction func donePressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
