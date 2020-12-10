//
//  Form781+CoreDataClass.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

import Foundation
import CoreData

@objc(Form781)
public class Form781: NSManagedObject {

    public init(date: String,
        mds: String,
        serialNumber: String,
        unitCharged: String,
        harmLocation: String,
        flightAuthNum: String,
        issuingUnit: String,
        grandTotalTime: Double? = nil,
        grandTotalTouchAndGo: Int? = nil,
        grandTotalFullStop: Int? = nil,
        grandTotalStops: Int? = nil,
        grandTotalSorties: Int? = nil,
        flights: [Flight] = [],
        crewMembers: [CrewMember] = []
    ) {
        self.date = date
        self.mds = mds
        self.serialNumber = serialNumber
        self.unitCharged = unitCharged
        self.harmLocation = harmLocation
        self.flightAuthNum = flightAuthNum
        self.issuingUnit = issuingUnit
        self.grandTotalTime = grandTotalTime
        self.grandTotalTouchAndGo = grandTotalTouchAndGo
        self.grandTotalFullStop = grandTotalFullStop
        self.grandTotalLandings = grandTotalStops
        self.grandTotalSorties = grandTotalSorties
        self.flights = flights
        self.crewMembers = crewMembers
    }
}

extension Form781: Equatable {
    
    //make sure it equals what we want it to
    static func ==(lhs: Form781, rhs: Form781) -> Bool {
        return (lhs.serialNumber == rhs.serialNumber)
    }
    
}
