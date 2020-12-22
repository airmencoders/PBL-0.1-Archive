//
//  DayTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 12/22/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class DayTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayBackgroundView: UIView!
    
    func setUpViews(date: String) {
        dayLabel.text = date
    }

} //End
