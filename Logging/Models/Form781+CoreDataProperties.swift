//
//  Form781+CoreDataProperties.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

import Foundation
import CoreData


extension Form781 {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Form781> {
        return NSFetchRequest<Form781>(entityName: "Form781")
    }

    @NSManaged public var date: String
    @NSManaged public var mds: String
    @NSManaged public var serialNumber: String
    @NSManaged public var unitCharged: String
    @NSManaged public var harmLocation: String
    @NSManaged public var flightAuthNum: String
    @NSManaged public var issuingUnit: String

    @NSManaged public var grandTotalTime: Double
    @NSManaged public var grandTotalTouchAndGo: Int32
    @NSManaged public var grandTotalFullStop: Int32
    @NSManaged public var grandTotalLandings: Int32
    @NSManaged public var grandTotalSorties: Int32

    @NSManaged public var flights: NSOrderedSet
    @NSManaged public var crewMembers: NSOrderedSet

}

// MARK: Generated accessors for flights
extension Form781 {

    @objc(insertObject:inFlightsAtIndex:)
    @NSManaged public func insertIntoFlights(_ value: Flight, at idx: Int)

    @objc(removeObjectFromFlightsAtIndex:)
    @NSManaged public func removeFromFlights(at idx: Int)

    @objc(insertFlights:atIndexes:)
    @NSManaged public func insertIntoFlights(_ values: [Flight], at indexes: NSIndexSet)

    @objc(removeFlightsAtIndexes:)
    @NSManaged public func removeFromFlights(at indexes: NSIndexSet)

    @objc(replaceObjectInFlightsAtIndex:withObject:)
    @NSManaged public func replaceFlights(at idx: Int, with value: Flight)

    @objc(replaceFlightsAtIndexes:withFlights:)
    @NSManaged public func replaceFlights(at indexes: NSIndexSet, with values: [Flight])

    @objc(addFlightsObject:)
    @NSManaged public func addToFlights(_ value: Flight)

    @objc(removeFlightsObject:)
    @NSManaged public func removeFromFlights(_ value: Flight)

    @objc(addFlights:)
    @NSManaged public func addToFlights(_ values: NSOrderedSet)

    @objc(removeFlights:)
    @NSManaged public func removeFromFlights(_ values: NSOrderedSet)

}

// MARK: Generated accessors for crewMembers
extension Form781 {

    @objc(insertObject:inCrewMembersAtIndex:)
    @NSManaged public func insertIntoCrewMembers(_ value: CrewMember, at idx: Int)

    @objc(removeObjectFromCrewMembersAtIndex:)
    @NSManaged public func removeFromCrewMembers(at idx: Int)

    @objc(insertCrewMembers:atIndexes:)
    @NSManaged public func insertIntoCrewMembers(_ values: [CrewMember], at indexes: NSIndexSet)

    @objc(removeCrewMembersAtIndexes:)
    @NSManaged public func removeFromCrewMembers(at indexes: NSIndexSet)

    @objc(replaceObjectInCrewMembersAtIndex:withObject:)
    @NSManaged public func replaceCrewMembers(at idx: Int, with value: CrewMember)

    @objc(replaceCrewMembersAtIndexes:withCrewMembers:)
    @NSManaged public func replaceCrewMembers(at indexes: NSIndexSet, with values: [CrewMember])

    @objc(addCrewMembersObject:)
    @NSManaged public func addToCrewMembers(_ value: CrewMember)

    @objc(removeCrewMembersObject:)
    @NSManaged public func removeFromCrewMembers(_ value: CrewMember)

    @objc(addCrewMembers:)
    @NSManaged public func addToCrewMembers(_ values: NSOrderedSet)

    @objc(removeCrewMembers:)
    @NSManaged public func removeFromCrewMembers(_ values: NSOrderedSet)

}
