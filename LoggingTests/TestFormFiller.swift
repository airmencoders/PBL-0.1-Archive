//
//  TestImageGenerator.swift
//  LoggingTests
//
//  Created by John Bethancourt on 12/17/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit
import XCTest
import CryptoKit

@testable import Logging

class TestFormFiller: XCTestCase {
    
    var forms = [Form781]()
    
    override func setUp() {
        
        let lastNames = ["Anderson", "Bernard", "Connor", "Daniels", "Engram", "Fredericks", "Goddard", "Harrison", "Ingraham", "Jacobson", "Kimmel", "Lucas", "Maryweather", "Nelson", "Osborne", "Pettersen", "Quesenberry", "Reese", "Stein", "Truman", "Underwood", "Victoria", "Wetherspoon", "X", "Young", "Zellman", "Angelos", "Barry", "Caldera", "Davidson", "Elfman", "Franks", "Goodman", "Hanks", "Ivy", "Jalrobi", "Keller", "Look", "Morrison", "Nelly", "Oglethorpe", "Prince", "Qui"]
         
        
        super.setUp()
        
        var date =  "23 Sep 2020"
        var mds = "SMC017A"
        var serialNumber = "99-0009"
        var unitCharged = "437 AW (HQ AMC) / DKFX"
        var harmLocation = "JB Charleston"
        var flightAuthNum = "20-0539"
        var issuingUnit = "0016AS"
        
        let form = Form781(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        
        let flightA = Flight(flightSeq: "a", missionNumber: "", missionSymbol: "Q1", fromICAO: "KCHS", toICAO: "KCHS", takeOffTime: "1800", landTime: "2100", totalTime: "3.0", touchAndGo: "", fullStop: "4", totalLandings: "4", sorties: "1", specialUse: "")
        
        form.flights = [flightA]
        
        let crewMember1 = CrewMember(lastName: "Bertram", firstName: "Gilfoyle", ssnLast4: "1234", flightAuthDutyCode: "IP B5", flyingOranization: "0016", primary: "1.5", secondary: nil, instructor: "1.5", evaluator: nil, other: "", time: "3.0", srty: "1", nightPSIE: "2.0", insPIE: "", simIns: nil, nvg: "2.0", combatTime: "", combatSrty: nil, combatSptTime: "", combatSptSrty: nil, resvStatus: "")
        
        let crewMember2 = CrewMember(lastName: "Chugtai", firstName: "Dinesh", ssnLast4: "1345", flightAuthDutyCode: "IP BJ", flyingOranization: "0016", primary: "1.5", secondary: nil, instructor: "1.5", evaluator: nil, other: "", time: "3.0", srty: "1", nightPSIE: "2.0", insPIE: "", simIns: nil, nvg: "2.0", combatTime: "", combatSrty: nil, combatSptTime: "", combatSptSrty: nil, resvStatus: "1")
        
        let crewMember3 = CrewMember(lastName: "LongLastName", firstName: "Monica", ssnLast4: "5322", flightAuthDutyCode: "IP BZ", flyingOranization: "1234", primary: "1.1", secondary: "2.2", instructor: "3.3", evaluator: "4.4", other: "5.5", time: "0.0", srty: "9", nightPSIE: "6.6", insPIE: "7.7", simIns: "8.8", nvg: "0.0", combatTime: "3.3", combatSrty: "4.4", combatSptTime: "5.5", combatSptSrty: "6.6", resvStatus: "33")
        
        form.crewMembers = [crewMember1, crewMember2, crewMember3]
        
        forms = [form]
        
        date =  "24 Sep 2021"
        mds = "SMC019A"
        serialNumber = "99-1119"
        unitCharged = "225 ADS (HQ PACAF) / ALWAYS BLUE"
        harmLocation = "JB Pearl Harbor - Hickam"
        flightAuthNum = "SIM"
        issuingUnit = "0016AS"
        
        let form2 = Form781(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        
        var form2Flights = [Flight]()
        let letters = Array("ABCDEFGHIJKL")
        
        for i in 0..<6{
            
            let flight = Flight(flightSeq: "a", missionNumber: "\(i)", missionSymbol: "Q\(i)", fromICAO: "KCH\(letters[i])", toICAO: "KCL\(letters[i])", takeOffTime: "180\(i)", landTime: "210\(i)", totalTime: "\(Double(i) * 1.0)", touchAndGo: "", fullStop: "\(i)", totalLandings: "\(i)", sorties: "\(i)", specialUse: "\(i)")
            
            form2Flights.append(flight)
            
        }
        
        form2.flights = form2Flights
        
        var t = 0.0
        for i in 0..<15{
            let social = String(format: "%04d", i)
            var res = i % 6 //resvStatus is 1, 2, 3, 4, or 33 or blank
            if res == 5 {
                res = 33
            }
            let resvStatus = res == 0 ? "" : "\(res)"
            
            let crewMember = CrewMember(lastName: lastNames[i], firstName: "Bill", ssnLast4: social, flightAuthDutyCode: "IP BZ", flyingOranization: "1234", primary: String(format: "%.1f", t + 0.1), secondary: String(format: "%.1f", t + 0.2), instructor: String(format: "%.1f", t + 0.3), evaluator: String(format: "%.1f", t + 0.4), other: String(format: "%.1f", t + 0.5), time: String(format: "%.1f", t + 0.6), srty: String(format: "%.1f", t + 0.7), nightPSIE: String(format: "%.1f", t + 0.8), insPIE: String(format: "%.1f", t + 0.9), simIns: String(format: "%.1f", t + 1.0), nvg: String(format: "%.1f", t + 1.1), combatTime: String(format: "%.1f", t + 1.2), combatSrty: String(format: "%.1f", t + 1.3), combatSptTime: String(format: "%.1f", t + 1.4), combatSptSrty: String(format: "%.1f", t + 1.5), resvStatus: resvStatus)
        
            form2.crewMembers.append(crewMember)
            t += 1.0
        }
        
        forms.append(form2)
         
    }
    
    func test781pdfFiller() throws {
        
        let form = self.forms[1]
        
        let filler = Form781pdfFiller(form781: form)
        
        let url = filler.pdfURL()
        
        XCTAssertTrue(url != nil)
        
        if let data = filler.pdfDocument()?.dataRepresentation() {
             
            XCTAssertEqual(1059043, data.count)
            
        }
        
    }
    
//    func testPDFtoDataTime() throws {
//
//        let form = self.forms[1]
//        
//        let filler = Form781pdfFiller(form781: form)
//
//        let doc = filler.pdfDocument()
//
//        measure {
//             _ = doc?.dataRepresentation()
//        }
//
//    }
     
}
