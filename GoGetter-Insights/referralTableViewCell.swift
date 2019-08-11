//
//  referralTableViewCell.swift
//  GoGetter Insights
//
//  Created by Austin Kang on 7/12/18.
//  Copyright © 2018 GoGetter. All rights reserved.
//

import Foundation
import UIKit

// The base custom cell I used for most custom cells
class referralTableViewCell: UITableViewCell {
    
    @IBOutlet weak var referralNumberLabel: UILabel!
    @IBOutlet weak var referrerLabel: UILabel!
    @IBOutlet weak var cellNumberLabel: UILabel!
    
    
}
// Custom cell for the [daily, weekly, monthly] popover view
class timeSelectorTableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
}

