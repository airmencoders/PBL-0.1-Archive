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
    
    
    func testGetTodaysDate() {
        let date = Helper.getTodaysDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Helper.DATE_FORMAT
        let testDate = dateFormatter.string(from: Date())
        
        XCTAssertEqual(date, testDate)
    }
    
    func testFileFound() {
       
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
        let url = path?.appendingPathComponent("Logging.json", isDirectory: false)
        var result = Helper.checkForFile(filePath: url!)
        if !result {
            Form781Controller.shared.create(date: Helper.getTodaysDate(), mds: "C017A", serialNumber: "90-0534", unitCharged: "437 AW (AMC) /DKFX", harmLocation: "JB CHARLESTON SC 29404", flightAuthNum: "20-0772", issuingUnit: "0016AS")
            result = Helper.checkForFile(filePath: url!)
        }
        XCTAssertTrue(result)
    }
    
    func testCheckInput() {
        let result = Helper().checkInput(time: "0900")
        XCTAssertTrue(result)
    }
    
    func testSeperateHours() {
        // Test requires input to have a colon
        let hrs = Helper.separateHoursAndMins(strInput: "10:00", pointer: "hour")
        XCTAssertEqual(hrs, "10")
    }
    
    func testSeperateMins() {
        // Test requires input to have a colon
        let min = Helper.separateHoursAndMins(strInput: "10:30", pointer: "min")
        XCTAssertEqual(min, "30")
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
    }

    private func _validateDateConversion(original: String, expected: String) {
        let date = Helper.dateFromString(original)
        XCTAssertNotNil(date)

        let dateString = Helper.stdFormattedDate(with: date!)
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
