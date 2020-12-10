//
//  CrewMember+CoreDataProperties.swift
//  
//
//  Created by Pete Hoch on 12/9/20.
//
//

import Foundation
import CoreData

extension CrewMember {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<CrewMember> {
        return NSFetchRequest<CrewMember>(entityName: "CrewMember")
    }

    @NSManaged public var lastName: String
    @NSManaged public var firstName: String
    @NSManaged public var ssnLast4: String
    @NSManaged public var flightAuthDutyCode: String
    @NSManaged public var flyingOrigin: String

    @NSManaged public var resvStatus: String?
    @NSManaged public var combatSptTime: String?
    @NSManaged public var combatSptSrty: String?
    @NSManaged public var combatSrty: String?
    @NSManaged public var combatTime: String?
    @NSManaged public var nvg: String?
    @NSManaged public var simIns: String?
    @NSManaged public var insPIE: String?
    @NSManaged public var nightPSIE: String?
    @NSManaged public var srty: String?
    @NSManaged public var time: String?
    @NSManaged public var other: String?
    @NSManaged public var evaluator: String?
    @NSManaged public var instructor: String?
    @NSManaged public var secondary: String?
    @NSManaged public var primary: String?
}
