//
//  FirstVCViewModel.swift
//  Logging
//
//  Created by Pete Misik on 10/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//
import UIKit
import PDFKit

struct Utilities {
    
    static func doesFileExist(atURL url: URL) -> Bool {
        do{
            return try url.checkResourceIsReachable()
        }catch{
            return false
            
        }
        
    }
    
    /**
     Validate time function is used to ensure the time entered lies within the 0000 - 2359 time frame.  The fuction breaks down the UITextField in to the 4 digits, converts it to an Int and then ensures it lies within the parameters of miltary time.
     
     - Parameter timeString: String - Represents the time to test
     
     - Throws: Form781Error.InvalidHours, Form781Error.InvalidMins
     
     - Returns: None
     
     Just a simple function to validate the hours and minutes
     */
    static func validateTime(_ timeString: String) throws {
        
        guard timeString.isExactlyFourCharacters()  else { throw Form781Error.InvalidTimeFormat }
        guard timeString.isDigits                   else { throw Form781Error.InvalidTimeFormat }
        
        let hours = Int(timeString.prefix(2))
        let mins =  Int(timeString.suffix(2))
        
        guard 0...23 ~= hours!  else { throw Form781Error.InvalidHours }
        guard 0...59 ~= mins!   else { throw Form781Error.InvalidHours }
        
    }
    
    
    static func timeBetween(_ start: String?, _ end: String?) -> String {
        
        guard let start = start?  .replacingOccurrences(of: ":", with: "") else { return "0" }
        guard let end = end?      .replacingOccurrences(of: ":", with: "") else { return "0" }
        guard start.isExactlyFourCharacters(),
              end.isExactlyFourCharacters(),
              start.isDigits,
              end.isDigits else {
            return "0"
        }
        
        let startHours =    Int(start.prefix(2))!
        let startMinutes =  Int(start.suffix(2))!
        let endHours =      Int(end.prefix(2))!
        let endMinutes =    Int(end.suffix(2))!
        
        var diffMin:    Int = 0
        var diffHrs:    Int = 0
        
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
        
        var tenthsOfAnHour = self.tenthsOfAnHour(from: diffMin)
        
        if tenthsOfAnHour == 10 {
            tenthsOfAnHour = 0
            diffHrs += 1
        }
        
        return "\(diffHrs).\(tenthsOfAnHour)"
    }
    
    
    /// Looks up decimal hours from a table that matches the conversion table found
    /// on the front of the AFTO Form 781
    ///
    /// The conversion table given by the form does not round evenly around the dial.
    /// While a formula could be used, it would be difficult to reason for new eyes. e.g.:
    /// ~~~
    /// return minutes < 30 ? Int(round((Double(minutes)/60.0) * 10)) : Int(round((Double(minutes)/61.0) * 10))
    /// ~~~
    /// A range table is accurate and easy to reason about.
    ///
    /// - Parameter minutes: The minutes after an hour (e.g. 11:31 then 31)
    ///
    /// - Returns: An integer representing the tenths of an hour based on the minutes given
    /// (e.g. 30 minutes would return 5 representing the tenths of 0.5)
    static func tenthsOfAnHour(from minutes: Int) -> Int {
        switch minutes {
        case 0...2:     return 0
        case 3...8:     return 1
        case 9...14:    return 2
        case 15...20:   return 3
        case 21...26:   return 4
        case 27...33:   return 5
        case 34...39:   return 6
        case 40...45:   return 7
        case 46...51:   return 8
        case 52...57:   return 9
        default:
                        return 10
        }
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
}
