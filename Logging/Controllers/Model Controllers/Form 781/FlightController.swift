//
//  FlightDataController.swift
//  Logging
//
//  Created by Bethany Morris on 10/26/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

class FlightController {
    
    static var flightsLoaded = false
    
    // MARK: - CRUD
    
    static func create(form: Form781, flightSeq: String, missionNumber: String, missionSymbol: String, fromICAO: String, toICAO: String, takeOffTime: String, landTime: String, totalTime: String, touchAndGo: String, fullStop: String, totalLandings: String, sorties: String, specialUse: String) {
            
        if let flight = Flight(flightSeq: flightSeq, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: takeOffTime, landTime: landTime, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse) {
        
            Form781Controller.shared.updateFormWith(flight: flight, form: form)
        }
    }
    
    static func calculateTotalTime() -> Double {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return 0
        }
        var totalTime = 0.0

        for flight in form.flights {
            if let flight = flight as? Flight {
                totalTime += Double(flight.totalTime) ?? 0.0
            }
        }
        return totalTime.truncate(places: 1)
    }
    
    static func calculateTotalTouchGo() -> Int {
        guard let form = Form781Controller.shared.getCurrentForm() else { return 0 }
        var touchGo = 0

        for flight in form.flights {
            if let flight = flight as? Flight {
                touchGo += Int(flight.touchAndGo) ?? 0
            }
        }
        return touchGo
    }
    
    static func calculateTotalFullStop() -> Int {
        guard let form = Form781Controller.shared.getCurrentForm() else { return 0 }
        var fullStop = 0

        for flight in form.flights {
            if let flight = flight as? Flight {
                fullStop += Int(flight.fullStop) ?? 0
            }
        }
        return fullStop
    }
    
    static func calculateTotalLandings() -> Int {
        guard let form = Form781Controller.shared.getCurrentForm() else { return 0 }
        var totalLandings = 0

        for flight in form.flights {
            if let flight = flight as? Flight {
                totalLandings += Int(flight.totalLandings) ?? 0
            }
        }
        return totalLandings
    }
    
    static func calculateTotalSorties() -> Int {
        guard let form = Form781Controller.shared.getCurrentForm() else { return 0 }
        var sorties = 0

        for flight in form.flights {
            if let flight = flight as? Flight {
                sorties += Int(flight.sorties) ?? 0
            }
        }
        return sorties
    }

} //End

extension Double {
    func truncate(places: Int) -> Double {
        return Double(ceil(pow(10.0, Double(places)) * self) / pow(10.0, Double(places)))
    }
}
