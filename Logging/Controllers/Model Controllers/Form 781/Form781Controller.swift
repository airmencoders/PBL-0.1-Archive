//
//  Form781Controller.swift
//  Logging
//
//  Created by Bethany Morris on 10/26/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

class Form781Controller {
    
    // MARK: - Singleton
    
    static let shared = Form781Controller()
    
    // MARK: - Notifications
    static let FLIGHT_DATA_CHANGED = NSNotification.Name("FlightDataChanged")

    // MARK: - Properties
    
    private var forms = [Form781]()
    var formCreated = false
    
    var loggingFileName = "Logging.json"

    // MARK: - Create
    
    func create(date: String, mds: String, serialNumber: String, unitCharged: String, harmLocation: String, flightAuthNum: String, issuingUnit: String) {
        let form = Form781(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        forms.append(form)
        formCreated = true
        populateFlights()
        populateCrewMembers()
        NSLog("Created form")
        save()
    }
    
    //populates from previous form
    func populateFlights() {
        if let flightsArray = getPreviousForm()?.flights {
            getCurrentForm()?.flights = flightsArray
            NSLog("Populated flights")
        }
    }
    
    //populates from previous form
    func populateCrewMembers() {
        if let crewMemberArray = getPreviousForm()?.crewMembers {
            getCurrentForm()?.crewMembers = crewMemberArray
            NSLog("Populated crew members")
        }
    }
    
    // MARK: - Update
    
    func updateMissionData(date: String, mds: String, serialNumber: String, unitCharged: String, harmLocation: String, flightAuthNum: String, issuingUnit: String) {
        
        guard let form = getCurrentForm() else {
            NSLog("ERROR: updateMissionData - Form781Controller has no current form. Mission Data not updated or saved.")
            return
        }
        form.date = date
        form.mds = mds
        form.serialNumber = serialNumber
        form.unitCharged = unitCharged
        form.harmLocation = harmLocation
        form.flightAuthNum = flightAuthNum
        form.issuingUnit = issuingUnit
        NSLog("Updated mission data")
        save()
    }
    
    func updateFormWith(flight: Flight, form: Form781) {
        form.flights.append(flight)
        NSLog("Added flight")
        save()
    }
    
    func updateFormWith(grandTotalTime: Double, grandTouchGo: Int, grandFullStop: Int, grandTotalLandings: Int, grandTotalSorties: Int, form: Form781) {
        form.grandTotalTime = grandTotalTime
        form.grandTotalTouchAndGo = grandTouchGo
        form.grandTotalFullStop = grandFullStop
        form.grandTotalLandings = grandTotalLandings
        form.grandTotalSorties = grandTotalSorties
        NSLog("Updated grand totals")
        save()
    }
    
    func updateFormwith(crewMember: CrewMember, form: Form781) {
        form.crewMembers.append(crewMember)
        NSLog("Added crew member")
        save()
    }
    
    func updateCrewMemberInfo(crewMember: CrewMember, lastName: String, firstName: String, ssnLast4: String, flightAuthDutyCode: String, flyingOranization: String) {
        
        crewMember.lastName = lastName
        crewMember.firstName = firstName
        crewMember.ssnLast4 = ssnLast4
        crewMember.flyingOranization = flyingOranization
        crewMember.flightAuthDutyCode = flightAuthDutyCode
                
        NSLog("Updated crew member info")
        save()
    }
    
    func updateCrewMemberTime(crewMember: CrewMember, primary: String, secondary: String, instructor: String, evaluator: String, other: String, time: String, srty: String, nightPSIE: String, insPIE: String, simIns: String, nvg: String, combatTime: String, combatSrty: String, combatSptTime: String, combatSptSrty: String, resvStatus: String) {
        
        crewMember.primary = primary
        crewMember.secondary = secondary
        crewMember.instructor = instructor
        crewMember.evaluator = evaluator
        crewMember.other = other
        crewMember.time = time
        crewMember.srty = srty
        crewMember.nightPSIE = nightPSIE
        crewMember.insPIE = insPIE
        crewMember.simIns = simIns
        crewMember.nvg = nvg
        crewMember.combatTime = combatTime
        crewMember.combatSrty = combatSrty
        crewMember.combatSptTime = combatSptTime
        crewMember.combatSptSrty = combatSptSrty
        crewMember.resvStatus = resvStatus
                
        NSLog("Updated crew member time")
        save()
    }
    
    func updateFlight(flight: Flight, missionNumber: String, missionSymbol: String, fromICAO: String, toICAO: String, takeOffTime: String, landTime: String, totalTime: String, touchAndGo: String, fullStop: String, totalLandings: String, sorties: String, specialUse: String) {
        
        flight.missionNumber = missionNumber
        flight.missionSymbol = missionSymbol
        flight.fromICAO = fromICAO
        flight.toICAO = toICAO
        flight.takeOffTime = takeOffTime
        flight.landTime = landTime
        flight.totalTime = totalTime
        flight.touchAndGo = touchAndGo
        flight.fullStop = fullStop
        flight.totalLandings = totalLandings
        flight.sorties = sorties
        flight.specialUse = specialUse
        
        NSLog("Updated flight")
        save()
    }
    
    // MARK: - Delete
    
    func remove(flight: Flight, from form: Form781) {
        guard let index = form.flights.firstIndex(of: flight) else {
            NSLog("WARNING: remove(flight: - Form781Controller tried to remove a flight that is not in the form. Flight = \(flight)")
            return
        }
        form.flights.remove(at: index)
        updateFlightSeqLetters()
        NSLog("Removed flight")
        save()
    }
    
    func updateFlightSeqLetters() {
        guard let flights = getCurrentForm()?.flights else {
            NSLog("WARNING: updateFlightSeqLetters() - No flights to update. currentForm = \(String(describing: getCurrentForm()))")
            return
        }
        for (index, flight) in flights.enumerated() {
            
            switch index {
            case 0:
                flight.flightSeq = "A"
            case 1:
                flight.flightSeq = "B"
            case 2:
                flight.flightSeq = "C"
            case 3:
                flight.flightSeq = "D"
            case 4:
                flight.flightSeq = "E"
            case 5:
                flight.flightSeq = "F"
            default:
                flight.flightSeq = ""
            }
        }
    }
    
    func remove(crewMember: CrewMember, from form: Form781) {
        guard let index = form.crewMembers.firstIndex(of: crewMember) else {
            NSLog("WARNING: remove(crewMember: - Form781Controller tried to remove a crew mwmber that is not in the form. CrewMember = \(crewMember)")
            return
        }
        form.crewMembers.remove(at: index)
        NSLog("Removed crew member")
        save()
    }
    
    func delete() {
        //delete form from array
    }
    
    // MARK: - Form access

    func numberOfForms() -> Int {
        return forms.count
    }

    func getCurrentForm() -> Form781? {
        return forms.last
    }

    func getPreviousForm() -> Form781? {
        let count = self.numberOfForms()
        if count > 1 {
            return forms[count - 2]
        }

        return nil
    }

    // MARK: - Persistance
    
    func fileURL(filename: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent(filename)
        //print("File URL: \(fileURL)")
        return fileURL
    }
    
    func save() {
        let encoder = JSONEncoder()
        do {
            encoder.outputFormatting = .prettyPrinted
            let data = try encoder.encode(forms)
            try data.write(to: fileURL(filename: loggingFileName), options: .completeFileProtectionUnlessOpen)
        } catch {
            NSLog("There was an error encoding the data: \(error.localizedDescription)")
        }
        // Let the world know that our data has changed.
        NotificationCenter.default.post(name: Form781Controller.FLIGHT_DATA_CHANGED, object: nil)
    }
    
    func loadForms() throws{
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL(filename: loggingFileName))
            forms = try decoder.decode([Form781].self, from: data)
        } catch {
            // No data to load, so clear out the array.
            forms = []
            throw error
        }
    }
        
} //End
 
