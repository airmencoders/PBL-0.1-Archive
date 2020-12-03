//
//  FirstVCViewModel.swift
//  Logging
//
//  Created by Pete Misik on 10/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//
import UIKit
import Foundation

class Helper {
    
    static let WIDTH: Int = 3300
    static let HEIGHT: Int = 2550

    static let DATE_FORMAT = "dd MMM yyyy"

    static func getTodaysDate() -> String {
        return stdFormattedDate(with: Date())
    }

    static func stdFormattedDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Helper.DATE_FORMAT
        let dateStr = dateFormatter.string(from: date)
        
        return dateStr
    }

    static func checkForFile(filePath: URL) -> Bool {
        NSLog("\(filePath.absoluteString)")
        var strPath = filePath.absoluteString
        strPath = strPath.replacingOccurrences(of: "file://", with: "")
        if FileManager.default.fileExists(atPath: strPath) {
            return true
        } else {
            return false
        }
    }
    
    func checkInput(time: String) -> Bool {
        if time.count == 4{
            return true
        } else {
            return false
        }
        
    }
    /**
        Function used to validate the input in to the field is a number
        - Parameters -  input: UITextField - input given
        - Throws - Form781Error.NotANumber
        - Returns - None
     */
    static func validateNumericalInput(input: UITextField) -> Bool {
       
            guard let _ = Int(input.text!) else { return false}
        return true
    }
    
    static func separateHoursAndMins(strInput: String, pointer: String) -> String {

        let index0 = strInput.index(strInput.startIndex, offsetBy: 0)
        let index1 = strInput.index(strInput.startIndex, offsetBy: 1)
        let index3 = strInput.index(strInput.startIndex, offsetBy: 3)
        let index4 = strInput.index(strInput.startIndex, offsetBy: 4)
        
        if pointer == "hour"{
            return "\(strInput[index0])\(strInput[index1])"
        } else {
            return "\(strInput[index3])\(strInput[index4])"
        }
    }

    static func vmCalculateLandings(touchAndGo: String, fullStop: String) -> String {
        // First we need to cast our text in to integers
        var intTouchAndGo: Int = 0
        var intFullStop: Int = 0
        
        if touchAndGo != "" {
            intTouchAndGo = Int(touchAndGo)!
        }
        
        
        if fullStop != "" {
            intFullStop = Int(fullStop)!
        }
        // Can't forget about input validation:
        
        let total = intTouchAndGo + intFullStop
        return "\(total)"
    }

    /**
        Validate time function is used to ensure the time entered lies within the 0000 - 2359 time frame.  The fuction breaks down the UITextField in to the 4 digits, converts it to an Int and then ensures it lies within the parameters of miltary time.

     - Parameter timeString: String - Represents the time to test

     - Throws: Form781Error.InvalidHours, Form781Error.InvalidMins

     - Returns: None
     
        Just a simple function to validate the hours and minutes
     */
    static func validateTime(timeString: String) throws {
        NSLog("Time: \(timeString)")
        if timeString.count > 0 {
            let hours: Int = Int("\(timeString[timeString.index(timeString.startIndex, offsetBy: 0)])\(timeString[timeString.index(timeString.startIndex, offsetBy: 1)])")!
            NSLog("Hours: \(hours)")
            if 0...23 ~= hours {
                NSLog("Valid hour")
            } else {
                NSLog("ERROR: Form781Error.InvalidHours")
                throw Form781Error.InvalidHours
            }

            let mins: Int = Int("\(timeString[timeString.index(timeString.startIndex, offsetBy: 2)])\(timeString[timeString.index(timeString.startIndex, offsetBy: 3)])")!
            NSLog("Minutes: \(mins)")
            if 0...59 ~= mins {
                NSLog("Valid mins")
            } else {
                NSLog("ERROR: Form781Error.InvalidMins")
                throw Form781Error.InvalidMins
            }
        }
    }

    static func vmCalculateTotalTime(takeOffTime: String?, landTime: String?) -> String {
        // Thought here is to calculate the flying hours.
        var diffMin: Int = 0
        var diffHrs: Int = 0
        var decMin: Int = 0

        var toHrsStr: String = ""
        var toMinStr: String = ""
        var laHrsStr: String = ""
        var laMinStr: String = ""

        var toHrsTime: Int
        var toMinTime: Int
        var laHrsTime: Int
        var laMinTime: Int

        // Technically, the first thing we should do is count characters to make sure

        guard let toTime = takeOffTime else {
            return "0"
        }
        guard let laTime = landTime else {
            return "0"
        }

        // First thing we need to do is see if someone put in a : by mistake
        let colon = CharacterSet(charactersIn: ":")
        if toTime.rangeOfCharacter(from: colon) != nil {
            toHrsStr = separateHoursAndMins(strInput: toTime, pointer: "hour")
            toMinStr = separateHoursAndMins(strInput: toTime, pointer: "min")
        } else {
            let hrIndex0 = toTime.index(toTime.startIndex, offsetBy: 0)
            let hrIndex1 = toTime.index(toTime.startIndex, offsetBy: 1)

            let mnIndex0 = toTime.index(toTime.startIndex, offsetBy: 2)
            let mnIndex1 = toTime.index(toTime.startIndex, offsetBy: 3)

            let hr0 = toTime[hrIndex0]
            let hr1 = toTime[hrIndex1]

            let mn0 = toTime[mnIndex0]
            let mn1 = toTime[mnIndex1]

            toHrsStr = "\(hr0)\(hr1)"
            toMinStr = "\(mn0)\(mn1)"
        }

        if laTime.rangeOfCharacter(from: colon) != nil {
            laHrsStr = separateHoursAndMins(strInput: laTime, pointer: "hour")
            laMinStr = separateHoursAndMins(strInput: laTime, pointer: "min")
        } else {
            let hrIndex0 = laTime.index(laTime.startIndex, offsetBy: 0)
            let hrIndex1 = laTime.index(laTime.startIndex, offsetBy: 1)

            let mnIndex0 = laTime.index(laTime.startIndex, offsetBy: 2)
            let mnIndex1 = laTime.index(laTime.startIndex, offsetBy: 3)

            let hr0 = laTime[hrIndex0]
            let hr1 = laTime[hrIndex1]

            let mn0 = laTime[mnIndex0]
            let mn1 = laTime[mnIndex1]

            laHrsStr = "\(hr0)\(hr1)"
            laMinStr = "\(mn0)\(mn1)"
        }

        laHrsTime = Int(laHrsStr)!
        toHrsTime = Int(toHrsStr)!

        laMinTime = Int(laMinStr)!
        toMinTime = Int(toMinStr)!

        if laHrsTime < toHrsTime {
            diffHrs = (laHrsTime - toHrsTime) + 24
        } else {
            diffHrs = laHrsTime - toHrsTime
        }

        if laMinTime < toMinTime {
            diffHrs -= 1
            diffMin = (laMinTime - toMinTime) + 60
        } else {
            diffMin = laMinTime - toMinTime
        }

        // Convert Int minutes to decimal minutes.
        if 0...2 ~= diffMin || 58...60 ~= diffMin{
            decMin = 0
        }
        if 3...8 ~= diffMin{
            decMin = 1
        }
        if 9...14 ~= diffMin{
            decMin = 2
        }
        if 15...20 ~= diffMin{
            decMin = 3
        }
        if 21...26 ~= diffMin{
            decMin = 4
        }
        if 27...33 ~= diffMin{
            decMin = 5
        }
        if 34...39 ~= diffMin{
            decMin = 6
        }
        if 40...45 ~= diffMin{
            decMin = 7
        }
        if 46...51 ~= diffMin{
            decMin = 8
        }
        if 52...57 ~= diffMin{
            decMin = 9
        }

        // NSLog("\(diffHrs)\(diffMin)")

        // return statement here
    
        return "\(diffHrs).\(decMin)"
    }
       
    
    static func highlightRed(textField: UITextField) {
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    static func unhighlight(textField: UITextField) {
        let color: UIColor = .fog
        textField.layer.borderColor = color.cgColor
    }

    func printFormFunc() {
        
        let formImage = UIImage(named: "afto781.jpg")
        let dataImage = generateImage()
        
        let size = CGSize(width: Helper.WIDTH, height: Helper.HEIGHT)
        UIGraphicsBeginImageContext(size)
        
        let areaSize = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        formImage!.draw(in: areaSize)
        dataImage!.draw(in: areaSize, blendMode: .normal, alpha: 0.8)
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "781_print"
        printInfo.outputType = .photo
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.showsNumberOfCopies = false
        
        printController.printingItem = newImage
        
        printController.present(animated: true, completionHandler: nil)

    }

    
    /**
     - The generateImage function is used to pull the data written in our JSON file and overlay it on an image of the AFTO Form 781.

     - Parameter none: All data is being retrieved from the stored JSON.

     - Throws: none

     - Returns: An image that can be rendered with the printController.
     
        throughout the function, any hard coded numbers represent pixels on the underlay image.  We use an NSAttributedString which gives the ability to control the font size.  Then we use the draw function to position it on the page.
     */

    func generateImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Helper.WIDTH, height: Helper.HEIGHT))
        
        let img = renderer.image { ctx in
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36)
            ]
            
            // MARK: - Section 1
            let form = Form781Controller.shared.forms.last
            
            let dateString = NSAttributedString(string: form?.date ?? " ", attributes: attrs)
            dateString.draw(with: CGRect(x: 330, y: 335, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let mdsString = NSAttributedString(string: form?.mds ?? " ", attributes: attrs)
            mdsString.draw(with: CGRect(x: 700, y: 335, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let serialNumberString = NSAttributedString(string: form?.serialNumber ?? " ", attributes: attrs)
            serialNumberString.draw(with: CGRect(x: 1035, y: 330, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let unitChargedString = NSAttributedString(string: form?.unitCharged ?? " ", attributes: attrs)
            unitChargedString.draw(with: CGRect(x: 1390, y: 330, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let harmLocationString = NSAttributedString(string: form?.harmLocation ?? " ", attributes: attrs)
            harmLocationString.draw(with: CGRect(x: 2120, y: 330, width: 980, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let flightAuthString = NSAttributedString(string: form?.flightAuthNum ?? " ", attributes: attrs)
            flightAuthString.draw(with: CGRect(x: 595, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let issuingUnitString = NSAttributedString(string: form?.issuingUnit ?? " ", attributes: attrs)
            issuingUnitString.draw(with: CGRect(x: 1130, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalTimeString = NSAttributedString(string: "\(form?.grandTotalTime ?? 0)", attributes: attrs)
            grandTotalTimeString.draw(with: CGRect(x: 1935, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalTandGString = NSAttributedString(string: "\(form?.grandTotalTouchAndGo ?? 0)", attributes: attrs)
            grandTotalTandGString.draw(with: CGRect(x: 2130, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalFullStopString = NSAttributedString(string: "\(form?.grandTotalFullStop ?? 0)", attributes: attrs)
            grandTotalFullStopString.draw(with: CGRect(x: 2260, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalLandingString = NSAttributedString(string: "\(form?.grandTotalLandings ?? 0)", attributes: attrs)
            grandTotalLandingString.draw(with: CGRect(x: 2370, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalSoritesString = NSAttributedString(string: "\(form?.grandTotalSorties ?? 0)", attributes: attrs)
            grandTotalSoritesString.draw(with: CGRect(x: 2500, y: 930, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            // MARK: - Flight Sequence
            
            for x in 0...(form!.flights.count - 1){
                let msnNumberString = NSAttributedString(string: form?.flights[x].missionNumber ?? " ", attributes: attrs)
                msnNumberString.draw(with: CGRect(x: 445, y: 545 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let msnSymbolString = NSAttributedString(string: form?.flights[x].missionSymbol ?? " ", attributes: attrs)
                msnSymbolString.draw(with: CGRect(x: 915, y: 545 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let fromICAOString = NSAttributedString(string: form?.flights[x].fromICAO ?? " ", attributes: attrs)
                fromICAOString.draw(with: CGRect(x: 1135, y: 545 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let toICAOString = NSAttributedString(string: form?.flights[x].toICAO ?? " ", attributes: attrs)
                toICAOString.draw(with: CGRect(x: 1325, y: 545 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let toTime = NSAttributedString(string: form?.flights[x].takeOffTime ?? " ", attributes: attrs)
                toTime.draw(with: CGRect(x: 1525, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let landTime = NSAttributedString(string: form?.flights[x].landTime ?? " ", attributes: attrs)
                landTime.draw(with: CGRect(x: 1710, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let totalTime = NSAttributedString(string: form?.flights[x].totalTime ?? " ", attributes: attrs)
                totalTime.draw(with: CGRect(x: 1935, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let touchAndGo = NSAttributedString(string: form?.flights[x].touchAndGo ?? " ", attributes: attrs)
                touchAndGo.draw(with: CGRect(x: 2130, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let fullStop = NSAttributedString(string: form?.flights[x].fullStop ?? " ", attributes: attrs)
                fullStop.draw(with: CGRect(x: 2260, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let totalLanding = NSAttributedString(string: form?.flights[x].totalLandings ?? " ", attributes: attrs)
                totalLanding.draw(with: CGRect(x: 2370, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let sorties = NSAttributedString(string: form?.flights[x].sorties ?? " ", attributes: attrs)
                sorties.draw(with: CGRect(x: 2500, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                
                let specialUse = NSAttributedString(string: form?.flights[x].specialUse ?? " ", attributes: attrs)
                specialUse.draw(with: CGRect(x: 2600, y: 545 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
            }
            
            
            
            
            // MARK: - AirCrew
            // Section 2
            if form!.crewMembers.count > 0 {
                for x in 0...form!.crewMembers.count - 1{
                    let orgString = NSAttributedString(string: form?.crewMembers[x].flyingOrigin ?? " ", attributes: attrs)
                    orgString.draw(with: CGRect(x: 325, y: 1210 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let last4String = NSAttributedString(string: form?.crewMembers[x].ssnLast4 ?? " ", attributes: attrs)
                    last4String.draw(with: CGRect(x: 465, y: 1210 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let lastNameString = NSAttributedString(string: form?.crewMembers[x].lastName ?? " ", attributes: attrs)
                    lastNameString.draw(with: CGRect(x: 595, y: 1210 + (x * 60), width: 505, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let flightAuthCodeString = NSAttributedString(string: form?.crewMembers[x].flightAuthDutyCode ?? " ", attributes: attrs)
                    flightAuthCodeString.draw(with: CGRect(x: 1130, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let primaryString = NSAttributedString(string: form?.crewMembers[x].primary ?? " ", attributes: attrs)
                    primaryString.draw(with: CGRect(x: 1380, y: 1210 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let secString = NSAttributedString(string: form?.crewMembers[x].secondary ?? " ", attributes: attrs)
                    secString.draw(with: CGRect(x: 1490, y: 1210 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let instString = NSAttributedString(string: form?.crewMembers[x].instructor ?? " ", attributes:  attrs)
                    instString.draw(with: CGRect(x: 1605, y: 1210 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let evalString = NSAttributedString(string: form?.crewMembers[x].evaluator ?? " ", attributes: attrs)
                    evalString.draw(with: CGRect(x: 1720, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let otherString = NSAttributedString(string: form?.crewMembers[x].other ?? " ", attributes: attrs)
                    otherString.draw(with: CGRect(x: 1840, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let timeTotalString = NSAttributedString(string: form?.crewMembers[x].time ?? " ", attributes: attrs)
                    timeTotalString.draw(with: CGRect(x: 1955, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let sortyTotalString = NSAttributedString(string: form?.crewMembers[x].srty ?? " ", attributes: attrs)
                    sortyTotalString.draw(with: CGRect(x: 2065, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let nightString = NSAttributedString(string: form?.crewMembers[x].nightPSIE ?? " ", attributes: attrs)
                    nightString.draw(with: CGRect(x: 2160, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let insPIEString = NSAttributedString(string: form?.crewMembers[x].insPIE ?? " ", attributes: attrs)
                    insPIEString.draw(with: CGRect(x: 2280, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let simInsString = NSAttributedString(string: form?.crewMembers[x].simIns ?? " ", attributes: attrs)
                    simInsString.draw(with: CGRect(x: 2400, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let nvgString = NSAttributedString(string: form?.crewMembers[x].nvg ?? " ", attributes: attrs)
                    nvgString.draw(with: CGRect(x: 2515, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtTimeString = NSAttributedString(string: form?.crewMembers[x].combatTime ?? " ", attributes: attrs)
                    cbtTimeString.draw(with: CGRect(x: 2630, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSrty ?? " ", attributes: attrs)
                    cbtSrtyString.draw(with: CGRect(x: 2730, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSptTimeString = NSAttributedString(string: form?.crewMembers[x].combatSptTime ?? " ", attributes: attrs)
                    cbtSptTimeString.draw(with: CGRect(x: 2830, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSptSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSptSrty ?? " ", attributes: attrs)
                    cbtSptSrtyString.draw(with: CGRect(x: 2940, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let resvStatusString = NSAttributedString(string: form?.crewMembers[x].resvStatus ?? " ", attributes: attrs)
                    resvStatusString.draw(with: CGRect(x: 3040, y: 1210 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                }
            }
        }
        
        return img
    }
//    func getPage1Info(date: String) {
//        let filepath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
//        let file = "swift/jsonHandler/Sources/jsonHandler/Resources/file.json"
//        // let fullpath = "\(filepath)\(file)"
//        let fileURL = filepath!.appendingPathComponent("test.json")
//    }
//
    // Try to turn the Sring contents into a Date object.
    // If we can not, return nil.
    static func dateFromString(_ dateStr: String) -> Date? {
        let dateFormatter = DateFormatter()
        let formats = ["d/M/y", "d-M-y", "d.M.y", "d M y", "M/d/y", "M-d-y", "M.d.y", "M d y"]

        for format in formats {
            dateFormatter.dateFormat = format
            if let date = dateFormatter.date(from: dateStr) {
                return date
            }
        }

        return nil
    }
} //End
