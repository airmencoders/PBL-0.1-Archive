//
//  CrewMemberController.swift
//  Logging
//
//  Created by Bethany Morris on 10/23/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

class CrewMemberController {
    
    //MARK: - CRUD
    
    static func create(form: Form781, lastName: String, firstName: String, ssnLast4: String, flightAuthDutyCode: String, flyingOranization: String) {
        
        let crewMember = CrewMember(lastName: lastName, firstName: firstName, ssnLast4: ssnLast4, flightAuthDutyCode: flightAuthDutyCode, flyingOranization: flyingOranization)
        
        Form781Controller.shared.updateFormwith(crewMember: crewMember, form: form)
    }
    
} //End
