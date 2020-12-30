//
//  Form781.swift
//  Logging
//
//  Created by Bethany Morris on 10/26/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

class Form781: Codable {
    
    var date: String
    var mds: String
    var serialNumber: String
    var unitCharged: String
    var harmLocation: String
    var flightAuthNum: String
    var issuingUnit: String
    
    var grandTotalTime: Double?
    var grandTotalTouchAndGo: Int?
    var grandTotalFullStop: Int?
    var grandTotalLandings: Int?
    var grandTotalSorties: Int?
    
    var flights: [Flight]
    var crewMembers: [CrewMember]
        
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
    
} //End

extension Form781: Equatable {
    
    //make sure it equals what we want it to
    static func ==(lhs: Form781, rhs: Form781) -> Bool {
        return (lhs.serialNumber == rhs.serialNumber)
    }
    
}
