//
//  FlightTimeTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func setUpViews(crewMember: CrewMember) {
        name.text = crewMember.lastName
    }
    
} //End

// MARK: - UITextField Delegate

extension FlightTimeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
