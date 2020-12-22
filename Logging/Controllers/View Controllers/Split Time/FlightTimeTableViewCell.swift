//
//  FlightTimeTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightTimeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var primary: UITextField!
    @IBOutlet weak var secondary: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var evaluator: UITextField!
    @IBOutlet weak var other: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var srty: UITextField!
    
    var crewMember: CrewMember?
    
    // MARK: - Methods
    
    func setUpViews(crewMember: CrewMember) {
        name.text = crewMember.lastName
        primary.text = crewMember.primary
        secondary.text = crewMember.secondary
        instructor.text = crewMember.instructor
        evaluator.text = crewMember.evaluator
        other.text = crewMember.other
        time.text = Helper.airCrewTotalTimeCalculation(crewMember: crewMember)
        srty.text = crewMember.srty
        
    }
    
} //End

// MARK: - UITextField Delegate

extension FlightTimeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
