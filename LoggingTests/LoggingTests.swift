//
//  LoggingTests.swift
//  LoggingTests
//
//  Created by Christian Brechbuhl on 7/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import XCTest
@testable import Logging

class LoggingTests: XCTestCase {

    func testFileCreationAndExistenceCheck() throws {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let url = path?.appendingPathComponent("Logging.json", isDirectory: false)

        Form781Controller.shared.create(date: Date().AFTOForm781String(), mds: "C017A", serialNumber: "90-0534", unitCharged: "437 AW (AMC) /DKFX", harmLocation: "JB CHARLESTON SC 29404", flightAuthNum: "20-0772", issuingUnit: "0016AS")
        
        XCTAssertTrue(Helper.doesFileExist(atURL: url!))
        
        let badPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let badURL = badPath?.appendingPathComponent("AlwaysBlue.json", isDirectory: false)
        
        XCTAssertFalse(Helper.doesFileExist(atURL: badURL!))

    }
    
    
    func testStringExtensions() {
        XCTAssertTrue("0900".isExactlyFourCharacters())
        XCTAssertFalse("090".isExactlyFourCharacters())
        
        XCTAssertTrue("0123".isDigits)
        XCTAssertFalse("123A".isDigits)
        
    }
    

    func testVmCalculateLandings() {
        let zero = Helper.vmCalculateLandings(touchAndGo: "", fullStop: "")
        XCTAssertEqual(zero, "0")

        let sum = Helper.vmCalculateLandings(touchAndGo: "5", fullStop: "4")
        XCTAssertEqual(sum, "9")
    }

    private func _isValidTime(timeString: String) -> Bool {
        do {
            let _ = try Helper.validateTime(timeString: timeString)
        } catch Form781Error.InvalidHours {
            return false
        } catch Form781Error.InvalidMins {
            return false
        } catch {
            XCTAssert(false, "validateTime throwing an unknown Error")
        }

        return true
    }

    func testValidateTime() {
        XCTAssertTrue(_isValidTime(timeString: "0000"))
        XCTAssertTrue(_isValidTime(timeString: "2359"))
        XCTAssertFalse(_isValidTime(timeString: "2400"))
        XCTAssertFalse(_isValidTime(timeString: "1260"))
        XCTAssertFalse(_isValidTime(timeString: "9999"))
    }

    func testVmCalculateTotalTime() {
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: nil, landTime: "2300"), "0")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0005"), "0.1")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0005", landTime: "2300"), "22.9")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "2301", landTime: "00:01"), "1.0")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "07:30", landTime: "14:35"), "7.1")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "20:12", landTime: "07:20"), "11.1")

        // Test all of the edge cases
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0001"), "0.0")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0002"), "0.0")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0003"), "0.1")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0008"), "0.1")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0009"), "0.2")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0014"), "0.2")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0015"), "0.3")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0020"), "0.3")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0021"), "0.4")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0026"), "0.4")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0027"), "0.5")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0033"), "0.5")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0034"), "0.6")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0039"), "0.6")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0040"), "0.7")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0045"), "0.7")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0046"), "0.8")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0051"), "0.8")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0052"), "0.9")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0057"), "0.9")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0058"), "1.0")
        XCTAssertEqual(Helper.vmCalculateTotalTime(takeOffTime: "0000", landTime: "0059"), "1.0")

    }

    private func _validateDateConversion(original: String, expected: String) {
        let date = Helper.dateFromString(original)
        XCTAssertNotNil(date)

        let dateString = date?.AFTOForm781String()
        XCTAssertEqual(dateString, expected)
    }

    func testDateFromString() {
        let date = Helper.dateFromString("this is not a date")
        XCTAssertNil(date)

        _validateDateConversion(original: "1/1/22", expected: "01 Jan 2022")
        _validateDateConversion(original: "1/2/22", expected: "01 Feb 2022")
        _validateDateConversion(original: "2/1/22", expected: "02 Jan 2022")

        // We can test a lot more date forms here.
    }
}//End
