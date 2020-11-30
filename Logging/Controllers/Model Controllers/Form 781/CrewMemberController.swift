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
    
    static func create(form: Form781, lastName: String, firstName: String, ssnLast4: String, flightAuthDutyCode: String, flyingOrigin: String) {
        
        let crewMember = CrewMember(lastName: lastName, firstName: firstName, ssnLast4: ssnLast4, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
        
        Form781Controller.shared.updateFormwith(crewMember: crewMember, form: form)
    }
    
//    static func create(form: Form781, lastName: String, firstName: String, ssnLast4: String, flightAuthDutyCode: String, flyingOrigin: String, primary: String, secondary: String, instructor: String, evaluator: String, other: String, time: String, srty: String, nightPSIE: String, insPIE: String, simIns: String, nvg: String, combatTime: String, combatSrty: String, combatSptTime: String, combatSptSrty: String, resvStatus: String) {
//
//        let crewMember = CrewMember(lastName: lastName, firstName: firstName, ssnLast4: ssnLast4, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
//
//        Form781Controller.shared.updateFormwith(crewMember: crewMember, form: form)
//    }
    
} //End
