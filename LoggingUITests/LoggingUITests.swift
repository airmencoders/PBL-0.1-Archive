//
//  LoggingUITests.swift
//  LoggingUITests
//
//  Created by Christian Brechbuhl on 7/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import XCTest
@testable import Logging

class LoggingUITests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func testEnteringApp() throws{
//
//        let app = XCUIApplication()
//        app.buttons["AFTO FORM 781"].tap()
//        app.buttons["SAVE & CONTINUE"].tap()
//
//    }
    

    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//
//
//        do {
//            try runMissionData(app: app)
////            do {
////                try addAFlight(app: app)
////            } catch {
////                print("Flight data error")
////            }
//        } catch {
//            NSLog("Mission Data Failure")
//        }
//
//    }
    func addAFlight(app: XCUIApplication) throws {
        let element = app.keyboards.children(matching: .other).element.children(matching: .other).element
        let moreKey = element/*@START_MENU_TOKEN@*/.children(matching: .key).matching(identifier: "more").element(boundBy: 0)/*[[".children(matching: .key).matching(identifier: \"letters\").element(boundBy: 0)",".children(matching: .key).matching(identifier: \"more\").element(boundBy: 0)"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        
        let tableName = "MISSION NUMBER, MISSION SYMBOL, FROM (ICAO), TO (ICAO), TAKE OFF TIME (Z), LAND TIME (Z), TOTAL TIME, TOUCH & GO, FULL STOP, TOTAL, SORTIES, SPECIAL USE"
        let predicate = NSPredicate(format: "label LIKE %@", tableName)
        
        app.tables.staticTexts.element(matching: predicate).buttons["add"].tap()
        
        app.textFields["ABCDEFGHIJ-1234567890"].tap()
        app.keys["A"].tap()
        app.keys["U"].tap()
        app.keys["N"].tap()
        moreKey.tap()
        app.keys["0"].tap()
        app.keys["3"].tap()
        moreKey.tap()
        app.keys["T"].tap()
        moreKey.tap()
        app.keys["1"].tap()
        app.keys["0"].tap()
        app.keys["3"].tap()
        app.keys["2"].tap()
        app.keys["0"].tap()
        app.keys["6"].tap()
        
    }
    
    func runMissionData(app: XCUIApplication) throws {
    
        app/*@START_MENU_TOKEN@*/.staticTexts["YES"]/*[[".buttons[\"YES\"].staticTexts[\"YES\"]",".staticTexts[\"YES\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        // Date auto-populated
        app.textFields["DD MMM YYY"].tap()
        //MDS
        if app.buttons["Keyboard"].exists{
            app.buttons["Keyboard"].tap()
            app.popovers.scrollViews.otherElements.buttons["Show Keyboard"].tap()
        }
        app.textFields["X-XX"].tap()
        app.keys["C"].tap()
        app.keys["P"].swipeDown()
        app.keys["Q"].swipeDown()
        app.keys["U"].swipeDown()
        app.keys["A"].tap()
        //Serial Number
        app.textFields["00-0000"].tap()

        app.keys["O"].swipeDown()
        app.keys["O"].swipeDown()
        app.keys["X"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["I"].swipeDown()
        app.keys["W"].swipeDown()


        //Unit Charged
        app.textFields["00 AB CDE FG"].tap()
    
        app.keys["R"].swipeDown()
        app.keys["E"].swipeDown()
        app.keys["U"].swipeDown()
        app.keys["space"].tap()
        app.keys["A"].tap()
        app.keys["W"].tap()
        
        app.keys["H"].swipeDown()
        
        app.keys["A"].tap()
        app.keys["M"].tap()
        app.keys["C"].tap()
        
        app.keys["J"].swipeDown()
        app.keys["B"].swipeDown()
        
        app.keys["D"].tap()
        app.keys["K"].tap()
        app.keys["F"].tap()
        app.keys["X"].tap()

        //Harm Location
        app.textFields["JOINT BASE CHARLESTON, SC 29404"].tap()
        app.keys["J"].tap()
        app.keys["B"].tap()
        app.keys["space"].tap()
        app.keys["C"].tap()
        app.keys["H"].tap()
        app.keys["A"].tap()
        app.keys["R"].tap()
        app.keys["L"].tap()
        app.keys["E"].tap()
        app.keys["S"].tap()
        app.keys["T"].tap()
        app.keys["O"].tap()
        app.keys["N"].tap()
        app.keys["space"].tap()
        app.keys["S"].tap()
        app.keys["C"].tap()
        app.keys["space"].tap()
        
        app.keys["W"].swipeDown()
        app.keys["O"].swipeDown()
        app.keys["R"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["R"].swipeDown()
        //Flight Auth #
        app.textFields["00-XXXX"].tap()
        
        app.keys["W"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["X"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["R"].swipeDown()
        app.keys["R"].swipeDown()
        app.keys["W"].swipeDown()
        //Issuing Unit

        app.textFields["00 AA"].tap()
        
        app.keys["P"].swipeDown()
        app.keys["P"].swipeDown()
        app.keys["Q"].swipeDown()
        app.keys["Y"].swipeDown()

        
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 4).buttons["SAVE & CONTINUE"].tap()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }


}
