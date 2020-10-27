//
//  FlightData.swift
//  Logging
//
//  Created by Bethany Morris on 10/26/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

class FlightData: Codable {
    
    var missionNumber: String
    var missionSymbol: String
    var fromICAO: String
    var toICAO: String
    var takeOffTime: String
    var landingTime: String
    var totalFlightTime: String
    var touchAndGo: String
    var fullStop: String
    var totalLanding: String
    var sorties: String
    var specialUse: String
    
    var grandTotalFlightTime: String?
    var grandTotalTouchAndGo: String?
    var grandTotalFullStop: String?
    var grandTotalStops: String?
    var grandTotalSorties: String?
    
    init(missionNumber: String,
         missionSymbol: String,
         fromICAO: String,
         toICAO: String,
         takeOffTime: String,
         landingTime: String,
         totalFlightTime: String,
         touchAndGo: String,
         fullStop: String,
         totalLanding: String,
         sorties: String,
         specialUse: String,
         grandTotalFlightTime: String,
         grandTotalTouchAndGo: String,
         grandTotalFullStop: String,
         grandTotalStops: String,
         grandTotalSorties: String) {
        
        self.missionNumber = missionNumber
        self.missionSymbol = missionSymbol
        self.fromICAO = fromICAO
        self.toICAO = toICAO
        self.takeOffTime = takeOffTime
        self.landingTime = landingTime
        self.totalFlightTime = totalFlightTime
        self.touchAndGo = touchAndGo
        self.fullStop = fullStop
        self.totalLanding = totalLanding
        self.sorties = sorties
        self.specialUse = specialUse
        self.grandTotalFlightTime = grandTotalFlightTime
        self.grandTotalTouchAndGo = grandTotalTouchAndGo
        self.grandTotalFullStop = grandTotalFullStop
        self.grandTotalStops = grandTotalStops
        self.grandTotalSorties = grandTotalSorties
    }
    
} //End
