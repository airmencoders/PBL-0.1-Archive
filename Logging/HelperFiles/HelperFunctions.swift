//
//  FirstVCViewModel.swift
//  Logging
//
//  Created by Pete Misik on 10/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//
import UIKit
import Foundation
import PDFKit

class Helper {
    
    static func doesFileExist(atURL url: URL) -> Bool {
        do{
            return try url.checkResourceIsReachable()
        }catch{
            return false
            
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
        
        guard timeString.isExactlyFourCharacters()  else { throw Form781Error.InvalidTimeFormat }
        guard timeString.isDigits                   else { throw Form781Error.InvalidTimeFormat }
        
        let hours = Int(timeString.prefix(2))
        let mins =  Int(timeString.suffix(2))
        
        guard 0...23 ~= hours!  else { throw Form781Error.InvalidHours }
        guard 0...59 ~= mins!   else { throw Form781Error.InvalidHours }
        
    }
    
    static func vmCalculateTotalTime(takeOffTime: String?, landTime: String?) -> String {
        
        guard let takeOffTime = takeOffTime?.replacingOccurrences(of: ":", with: "") else { return "0" }
        guard let landTime = landTime?      .replacingOccurrences(of: ":", with: "") else { return "0" }
        guard takeOffTime.isExactlyFourCharacters(),
              landTime.isExactlyFourCharacters(),
              takeOffTime.isDigits,
              landTime.isDigits else {
            return "0"
        }
        
        let startHours = Int(takeOffTime.prefix(2))!
        let startMinutes = Int(takeOffTime.suffix(2))!
        let endHours = Int(landTime.prefix(2))!
        let endMinutes = Int(landTime.suffix(2))!
        
        var diffMin: Int = 0
        var diffHrs: Int = 0
        var decMin: Int = 0
        
        if endHours < startHours {
            diffHrs = (endHours - startHours) + 24
        } else {
            diffHrs = endHours - startHours
        }
        
        if endMinutes < startMinutes {
            diffHrs -= 1
            diffMin = (endMinutes - startMinutes) + 60
        } else {
            diffMin = endMinutes - startMinutes
        }
        
        decMin = decimalTime(num: Double(diffMin))
        
        if decMin == 10 {
            decMin = 0
            diffHrs += 1
        }
        
        return "\(diffHrs).\(decMin)"
    }
    
    static func decimalTime(num: Double) -> Int {
        // This is the general idea, but it does not work all the way around the dial.
        // return (num / 6.0).rounded()
        // The problem is that the form table does not round evenly around the dial.
        // For example, 33/6 = 5.5, it should trunk to 5 but it rounds to 6. But you
        // can't just trunk for minutes greater than 30, becasue 34/6 = 5.6666, so
        // in this case you want to round.
        // So the range table seemed the most accurate way.
        if 0...2 ~= num {
            return 0
        } else if 3...8 ~= num {
            return 1
        } else if 9...14 ~= num {
            return 2
        } else if 15...20 ~= num {
            return 3
        } else if 21...26 ~= num {
            return 4
        } else if 27...33 ~= num {
            return 5
        } else if 34...39 ~= num {
            return 6
        } else if 40...45 ~= num {
            return 7
        } else if 46...51 ~= num {
            return 8
        } else if 52...57 ~= num {
            return 9
        }
        return 10
    }

    // Turn the String contents into a Date object. Return nil on failure.

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
    
    static func airCrewTotalTimeCalculation(crewMember: CrewMember) -> String {
        var total: Double = 0.0
        
        let dblPrimary = Double(crewMember.primary ?? "0.0")
        let dblSecondary = Double(crewMember.secondary ?? "0.0")
        let dblInstructor = Double(crewMember.instructor ?? "0.0")
        let dblEval = Double(crewMember.evaluator ?? "0.0")
        
        total += dblPrimary ?? 0.0
        total += dblSecondary ?? 0.0
        total += dblInstructor ?? 0.0
        total += dblEval ?? 0.0
        
        return String(total)
    }
    
}
