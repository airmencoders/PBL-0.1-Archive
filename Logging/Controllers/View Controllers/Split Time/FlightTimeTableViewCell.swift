//
//  FlightTimeTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightTimeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets & Properties

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
<<<<<<< HEAD
        time.text = crewMember.totalAirTime()
        srty.text = crewMember.srty
        
        primary.delegate = self
        secondary.delegate = self
        instructor.delegate = self
        evaluator.delegate = self
        other.delegate = self
        time.delegate = self
        srty.delegate = self
=======
        time.text = Helper.airCrewTotalTimeCalculation(crewMember: crewMember)
        srty.text = crewMember.srty
        
>>>>>>> 505c14056ffb901d5c20f916bf8d009f1facde08
    }
    
} //End

// MARK: - UITextField Delegate

extension FlightTimeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
