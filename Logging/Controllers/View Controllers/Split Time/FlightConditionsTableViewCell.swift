//
//  FlightConditionsTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightConditionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var night: UILabel!
    @IBOutlet weak var ins: UILabel!
    @IBOutlet weak var simIns: UILabel!
    @IBOutlet weak var nvg: UILabel!
    @IBOutlet weak var combatTime: UILabel!
    @IBOutlet weak var combatSrty: UILabel!
    @IBOutlet weak var combatSptTime: UILabel!
    @IBOutlet weak var combatSptSrty: UILabel!
    @IBOutlet weak var resv: UILabel!

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
    }

} //End

// MARK: - UITextField Delegate

extension FlightConditionsTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
