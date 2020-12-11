//
//  CrewMember+CoreDataClass.swift
//  
//
//  Created by Pete Hoch on 12/9/20.
//
//

/*
 From: AFTO Form 781 descriptions and inputs
 
 Number Field               Description                 Detail
 19     flyingOrigin        flying organization 0016    tied to crew member, should populate from Puckboard
 ATTN: Should this be renamed to flyingOrganization?

 20     ssnLast4                                        tied to crew memeber?
 21     lastName                                        should populate from Puckboard
 22     flightAuthDutyCode  4-5 digit alpha numeric     default to persons crew qualification, should populate from Puckboard
                            qualification code
 23     primary (PRIM)      primay (# of hours flown)   decimal hours
 24     secondary (SEC)     secondary                   decimal hours
 25     instructor (INSTR)  instructor                  decimal hours
 26     evaluator (EVAL)    evaluator                   decimal hours
 27     other (OTHER )      other                       decimal hours
 28     time                grand total of 23-28 for    cannot exceed total flight time (13)
                            that person
 29     srty                                            should be able to edit
 30     nightPSIE           combat time/support - up    decimal hours
                            to total time of each crew
                            member, loadmasters and
                            flight attendants can
                            exceed total flight time
 31     insPIE              combat time/support - up    decimal hours
                            to total time of each crew
                            member, loadmasters and
                            flight attendants can
                            exceed total flight time
 32     simIns              combat time/support - up    decimal hours, cannot exceed total flight time
                            to total time of each crew
                            member, loadmasters and
                            flight attendants can
                            exceed total flight time
 33     nvg                 combat time/support - up    decimal hours, cannot exceed total flight time
                            to total time of each crew
                            member, loadmasters and
                            flight attendants can
                            exceed total flight time
 34     combatTime          combat time/support - up    decimal hours, cannot exceed total flight time
                            to total time of each crew
                            member
 35     combatSrty          # of sorties                whole numbers
 36     combatSptTime                                   decimal hours
 37     combatSptSrty       # of sorties                whole numbers
 38     resvStatus          number 1-5, way to get paid can be 1, 2, 3, 33, 4 (33 is double 3 shift)
 
 *** Fields we do not seem to have data for. Other than line 40? ***
 39    MAINT REVIEW         abcdef, initials            Maintenance member, not in puckboard
 40    PILOT REVIEW         pilot name                   should default from above (first name listed on crew list)
 41    SARM REVIEW          not needed in upload version
 42    ARMS INPUT/AUDIT     not needed in upload version
 43    EXTRACT CERTIFICATION (if required)    not needed in upload version
 
*** Data collected we do not seem to need. ***
 @NSManaged public var firstName: String?
 */

import UIKit
import CoreData

public class CrewMember: NSManagedObject {

    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    init?(lastName: String,
         firstName: String,
         ssnLast4: String,
         flightAuthDutyCode: String,
         flyingOrigin: String,
         primary: String? = nil,
         secondary: String? = nil,
         instructor: String? = nil,
         evaluator: String? = nil,
         other: String? = nil,
         time: String? = nil,
         srty: String? = nil,
         nightPSIE: String? = nil,
         insPIE: String? = nil,
         simIns: String? = nil,
         nvg: String? = nil,
         combatTime: String? = nil,
         combatSrty: String? = nil,
         combatSptTime: String? = nil,
         combatSptSrty: String? = nil,
         resvStatus: String? = nil) {
        
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let Context = context else {
            return nil
        }
        guard let entitiyDesc = NSEntityDescription.entity(forEntityName: "CrewMember", in: Context) else {
            return nil
        }
        super.init(entity: entitiyDesc, insertInto: context)

        self.lastName = lastName
        self.firstName = firstName
        self.ssnLast4 = ssnLast4
        self.flightAuthDutyCode = flightAuthDutyCode
        self.flyingOrigin = flyingOrigin
        self.primary = primary
        self.secondary = secondary
        self.instructor = instructor
        self.evaluator = evaluator
        self.other = other
        self.time = time
        self.srty = srty
        self.nightPSIE = nightPSIE
        self.insPIE = insPIE
        self.simIns = simIns
        self.nvg = nvg
        self.combatTime = combatTime
        self.combatSrty = combatSrty
        self.combatSptTime = combatSptTime
        self.combatSptSrty = combatSptSrty
        self.resvStatus = resvStatus
    }
}

extension CrewMember {  //: Equatable {
    
    // make sure it equals what we want it to
    static func ==(lhs: CrewMember, rhs: CrewMember) -> Bool {
        return (lhs.lastName == rhs.lastName) && (lhs.ssnLast4 == rhs.ssnLast4)
    }
}
