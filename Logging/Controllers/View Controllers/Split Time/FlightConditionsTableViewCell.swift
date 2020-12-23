//
//  FlightConditionsTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightConditionsTableViewCell: UITableViewCell {
    
    // MARK: - Outlets & Properties
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var night: UITextField!
    @IBOutlet weak var ins: UITextField!
    @IBOutlet weak var simIns: UITextField!
    @IBOutlet weak var nvg: UITextField!
    @IBOutlet weak var combatTime: UITextField!
    @IBOutlet weak var combatSrty: UITextField!
    @IBOutlet weak var combatSptTime: UITextField!
    @IBOutlet weak var combatSptSrty: UITextField!
    @IBOutlet weak var resv: UITextField!
    
    var crewMember: CrewMember?
    
    // MARK: - Methods

    func setUpViews(crewMember: CrewMember) {
        name.text = crewMember.lastName
        night.text = crewMember.nightPSIE
        ins.text = crewMember.insPIE
        simIns.text = crewMember.simIns
        nvg.text = crewMember.nvg
        combatTime.text = crewMember.combatTime
        combatSrty.text = crewMember.combatSrty
        combatSptTime.text = crewMember.combatSptTime
        combatSptSrty.text = crewMember.combatSptSrty
        resv.text = crewMember.resvStatus
        
        night.delegate = self
        ins.delegate = self
        simIns.delegate = self
        nvg.delegate = self
        combatTime.delegate = self
        combatSrty.delegate = self
        combatSptTime.delegate = self
        combatSptSrty.delegate = self
        resv.delegate = self
    }

} //End

// MARK: - UITextField Delegate

extension FlightConditionsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
