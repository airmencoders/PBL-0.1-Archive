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
    }
    
    func updateTextFields(toEnabled: Bool) {
        primary.isUserInteractionEnabled = toEnabled
        secondary.isUserInteractionEnabled = toEnabled
        instructor.isUserInteractionEnabled = toEnabled
        evaluator.isUserInteractionEnabled = toEnabled
        other.isUserInteractionEnabled = toEnabled
        time.isUserInteractionEnabled = toEnabled
        srty.isUserInteractionEnabled = toEnabled
        
        if toEnabled {
            primary.borderStyle = .roundedRect
        } else {
            primary.borderStyle = .none
        }
    }
    
} //End

// MARK: - UITextField Delegate

extension FlightTimeTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
