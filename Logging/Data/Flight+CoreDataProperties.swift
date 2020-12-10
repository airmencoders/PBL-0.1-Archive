//
//  Flight+CoreDataProperties.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

import Foundation
import CoreData


extension Flight {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Flight> {
        return NSFetchRequest<Flight>(entityName: "Flight")
    }

    @NSManaged public var flightSeq: String
    @NSManaged public var missionNumber: String
    @NSManaged public var missionSymbol: String
    @NSManaged public var fromICAO: String
    @NSManaged public var toICAO: String
    @NSManaged public var takeOffTime: String
    @NSManaged public var landTime: String
    @NSManaged public var totalTime: String
    @NSManaged public var touchAndGo: String
    @NSManaged public var fullStop: String
    @NSManaged public var totalLandings: String
    @NSManaged public var sorties: String
    @NSManaged public var specialUse: String
}
