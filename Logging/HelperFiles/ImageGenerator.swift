//
//  ImageGenerator.swift
//  Logging
//
//  Created by Pete Misik on 12/4/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation
import UIKit

class ImageGenerator {
    
    /// Generates a `UIImage` with the contents of the current Form781Controller singleton fields overlayed on top of an image of the AFTO Form 781.
    ///
    /// Returns nil when if the form can not be generated
    static func generateFilledFormPageOneImage(from form: Form781) -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: Constants.letterPaperResolution)
        
        let img = renderer.image { ctx in
            // MARK: - AFTO 781 Section I. Mission Data
            let height = 50
            
            // string and numeric extensions at end of file handle the drawIn method
            form.date.drawIn(                      CGRect(x: 250,  y: 245, width: 300, height: height))
            form.mds.drawIn(                       CGRect(x: 700,  y: 245, width: 300, height: height))
            form.serialNumber.drawIn(              CGRect(x: 1035, y: 245, width: 300, height: height))
            form.unitCharged.drawIn(               CGRect(x: 1390, y: 245, width: 900, height: height))
            form.harmLocation.drawIn(              CGRect(x: 2120, y: 245, width: 980, height: height))
            form.flightAuthNum.drawIn(             CGRect(x: 545,  y: 820, width: 300, height: height))
            form.issuingUnit.drawIn(               CGRect(x: 1085, y: 820, width: 300, height: height))
            form.grandTotalTime?.drawIn(           CGRect(x: 1875, y: 820, width: 300, height: height))
            form.grandTotalTouchAndGo?.drawIn(     CGRect(x: 2060, y: 820, width: 300, height: height))
            form.grandTotalFullStop?.drawIn(       CGRect(x: 2200, y: 820, width: 300, height: height))
            form.grandTotalLandings?.drawIn(       CGRect(x: 2310, y: 820, width: 300, height: height))
            form.grandTotalSorties?.drawIn(        CGRect(x: 2490, y: 820, width: 300, height: height))
            
            
            // MARK: *Flight Sequence
            if form.flights.count > 0 {
                
                // temp: changed var to i from x to prevent confusion with x in the CGRect.
                for i in 0...(form.flights.count - 1){
                    
                    let flight = form.flights[i]
                    
                    let ysp = 60
                    
                    flight.missionNumber.drawIn(    CGRect(x: 345,  y: 455 + (i * ysp), width: 300, height: height))
                    flight.missionSymbol.drawIn(    CGRect(x: 825,  y: 455 + (i * ysp), width: 300, height: height))
                    flight.fromICAO.drawIn(         CGRect(x: 1045, y: 455 + (i * ysp), width: 300, height: height))
                    flight.toICAO.drawIn(           CGRect(x: 1265, y: 455 + (i * ysp), width: 300, height: height))
                    flight.takeOffTime.drawIn(      CGRect(x: 1465, y: 455 + (i * ysp), width: 200, height: height))
                    flight.landTime.drawIn(         CGRect(x: 1680, y: 455 + (i * ysp), width: 200, height: height))
                    flight.totalTime.drawIn(        CGRect(x: 1875, y: 455 + (i * ysp), width: 200, height: height))
                    flight.touchAndGo.drawIn(       CGRect(x: 2060, y: 455 + (i * ysp), width: 200, height: height))
                    flight.fullStop.drawIn(         CGRect(x: 2200, y: 455 + (i * ysp), width: 200, height: height))
                    flight.totalLandings.drawIn(    CGRect(x: 2310, y: 455 + (i * ysp), width: 200, height: height))
                    flight.sorties.drawIn(          CGRect(x: 2490, y: 455 + (i * ysp), width: 200, height: height))
                    flight.specialUse.drawIn(       CGRect(x: 2590, y: 455 + (i * ysp), width: 200, height: height))
                }
            }
            
            // MARK:  - AFTO 781 Section II. Aircrew Data
            
            // I need to determine if the crew count exceeds the number of rows on the front of the form.
            if form.crewMembers.count > 0 {
                
                let crewSize: Int = form.crewMembers.count
                
                if crewSize <= 15 {
                    
                    for i in 0..<crewSize {
                        
                        let member = form.crewMembers[i]
                        
                        let ys = 59
                        
                        member.flyingOranization.drawIn(    CGRect(x: 175,  y: 1085 + (i * ys), width: 100, height: height))
                        member.ssnLast4.drawIn(             CGRect(x: 315,  y: 1085 + (i * ys), width: 100, height: height))
                        member.lastName.drawIn(             CGRect(x: 455,  y: 1085 + (i * ys), width: 505, height: height))
                        member.flightAuthDutyCode.drawIn(   CGRect(x: 1035, y: 1085 + (i * ys), width: 200, height: height))
                        member.primary?.drawIn(             CGRect(x: 1270, y: 1085 + (i * ys), width: 200, height: height))
                        member.secondary?.drawIn(           CGRect(x: 1390, y: 1085 + (i * ys), width: 200, height: height))
                        member.instructor?.drawIn(          CGRect(x: 1520, y: 1085 + (i * ys), width: 100, height: height))
                        member.evaluator?.drawIn(           CGRect(x: 1640, y: 1085 + (i * ys), width: 200, height: height))
                        member.other?.drawIn(               CGRect(x: 1760, y: 1085 + (i * ys), width: 200, height: height))
                        member.time?.drawIn(                CGRect(x: 1885, y: 1085 + (i * ys), width: 200, height: height))
                        member.srty?.drawIn(                CGRect(x: 1990, y: 1085 + (i * ys), width: 200, height: height))
                        member.nightPSIE?.drawIn(           CGRect(x: 2100, y: 1085 + (i * ys), width: 200, height: height))
                        member.insPIE?.drawIn(              CGRect(x: 2220, y: 1085 + (i * ys), width: 200, height: height))
                        member.simIns?.drawIn(              CGRect(x: 2340, y: 1085 + (i * ys), width: 200, height: height))
                        member.nvg?.drawIn(                 CGRect(x: 2460, y: 1085 + (i * ys), width: 200, height: height))
                        member.combatTime?.drawIn(          CGRect(x: 2580, y: 1085 + (i * ys), width: 200, height: height))
                        member.combatSrty?.drawIn(          CGRect(x: 2690, y: 1085 + (i * ys), width: 200, height: height))
                        member.combatSptTime?.drawIn(       CGRect(x: 2800, y: 1085 + (i * ys), width: 200, height: height))
                        member.combatSptSrty?.drawIn(       CGRect(x: 2910, y: 1085 + (i * ys), width: 200, height: height))
                        member.resvStatus?.drawIn(          CGRect(x: 3000, y: 1085 + (i * ys), width: 200, height: height))
                        
                    }
                } else {
                    
                    for i in 0...14 {
                        
                        let member = form.crewMembers[i]
                        
                        member.flyingOranization.drawIn(    CGRect(x: 325,  y: 1210 + (i * 60), width: 100, height: height))
                        member.ssnLast4.drawIn(             CGRect(x: 465,  y: 1210 + (i * 60), width: 100, height: height))
                        member.lastName.drawIn(             CGRect(x: 595,  y: 1210 + (i * 60), width: 505, height: height))
                        member.flightAuthDutyCode.drawIn(   CGRect(x: 1130, y: 1210 + (i * 60), width: 200, height: height))
                        member.primary?.drawIn(             CGRect(x: 1380, y: 1210 + (i * 60), width: 50,  height: height))
                        member.secondary?.drawIn(           CGRect(x: 1490, y: 1210 + (i * 60), width: 50,  height: height))
                        member.instructor?.drawIn(          CGRect(x: 1605, y: 1210 + (i * 60), width: 50,  height: height))
                        member.evaluator?.drawIn(           CGRect(x: 1720, y: 1210 + (i * 60), width: 200, height: height))
                        member.other?.drawIn(               CGRect(x: 1840, y: 1210 + (i * 60), width: 200, height: height))
                        member.time?.drawIn(                CGRect(x: 1955, y: 1210 + (i * 60), width: 200, height: height))
                        member.srty?.drawIn(                CGRect(x: 2065, y: 1210 + (i * 60), width: 200, height: height))
                        member.nightPSIE?.drawIn(           CGRect(x: 2160, y: 1210 + (i * 60), width: 200, height: height))
                        member.insPIE?.drawIn(              CGRect(x: 2280, y: 1210 + (i * 60), width: 200, height: height))
                        member.simIns?.drawIn(              CGRect(x: 2400, y: 1210 + (i * 60), width: 200, height: height))
                        member.nvg?.drawIn(                 CGRect(x: 2515, y: 1210 + (i * 60), width: 200, height: height))
                        member.combatTime?.drawIn(          CGRect(x: 2630, y: 1210 + (i * 60), width: 200, height: height))
                        member.combatSrty?.drawIn(          CGRect(x: 2730, y: 1210 + (i * 60), width: 200, height: height))
                        member.combatSptTime?.drawIn(       CGRect(x: 2830, y: 1210 + (i * 60), width: 200, height: height))
                        member.combatSptSrty?.drawIn(       CGRect(x: 2940, y: 1210 + (i * 60), width: 200, height: height))
                        member.resvStatus?.drawIn(          CGRect(x: 3080, y: 1210 + (i * 60), width: 200, height: height))
                        
                    }
                }
            }
        }
        return img
    }
    /**
     - The generateBackOfForm function is used to pull the data written in our JSON file and overlay it on an image of the front of the xAFTO Form 781.
     
     - Parameter none: All data is being retrieved from the stored JSON.
     
     - Throws: none
     
     - Returns: An image that can be rendered with the printController.
     
     throughout the function, any hard coded numbers represent pixels on the underlay image.  We use an NSAttributedString which gives the ability to control the font size.  Then we use the draw function to position it on the page.
     */
    static func generateFilledFormPageTwoImage(from form: Form781) -> UIImage? {
        
        let renderer = UIGraphicsImageRenderer(size: Constants.letterPaperResolution)
        
        let backOfForm = renderer.image { ctx in
            
            // MARK: - Crew finishing
            
            let crewSize: Int = form.crewMembers.count
            
            if crewSize >= 15 {
                
                let remainingCrew = crewSize - 15
                
                let height = 50
                
                for i in 0...remainingCrew {
                    
                    let member = form.crewMembers[i]
                    
                    member.flyingOranization.drawIn(    CGRect(x: 310,  y: 705 + (i * 60), width: 100,  height: height))
                    member.ssnLast4.drawIn(             CGRect(x: 450,  y: 705 + (i * 60), width: 100,  height: height))
                    member.lastName.drawIn(             CGRect(x: 580,  y: 705 + (i * 60), width: 505,  height: height))
                    member.flightAuthDutyCode.drawIn(   CGRect(x: 1115, y: 705 + (i * 60), width: 200,  height: height))
                    member.primary?.drawIn(             CGRect(x: 1365, y: 705 + (i * 60), width: 50,   height: height))
                    member.secondary?.drawIn(           CGRect(x: 1475, y: 705 + (i * 60), width: 50,   height: height))
                    member.instructor?.drawIn(          CGRect(x: 1590, y: 705 + (i * 60), width: 50,   height: height))
                    member.evaluator?.drawIn(           CGRect(x: 1705, y: 705 + (i * 60), width: 200,  height: height))
                    member.other?.drawIn(               CGRect(x: 1825, y: 705 + (i * 60), width: 200,  height: height))
                    member.time?.drawIn(                CGRect(x: 1940, y: 705 + (i * 60), width: 200,  height: height))
                    member.srty?.drawIn(                CGRect(x: 2050, y: 705 + (i * 60), width: 200,  height: height))
                    member.nightPSIE?.drawIn(           CGRect(x: 2145, y: 705 + (i * 60), width: 200,  height: height))
                    member.insPIE?.drawIn(              CGRect(x: 2265, y: 705 + (i * 60), width: 200,  height: height))
                    member.simIns?.drawIn(              CGRect(x: 2385, y: 705 + (i * 60), width: 200,  height: height))
                    member.nvg?.drawIn(                 CGRect(x: 2500, y: 705 + (i * 60), width: 200,  height: height))
                    member.combatTime?.drawIn(          CGRect(x: 2615, y: 705 + (i * 60), width: 200,  height: height))
                    member.combatSrty?.drawIn(          CGRect(x: 2715, y: 705 + (i * 60), width: 200,  height: height))
                    member.combatSptTime?.drawIn(       CGRect(x: 2815, y: 705 + (i * 60), width: 200,  height: height))
                    member.combatSptSrty?.drawIn(       CGRect(x: 2925, y: 705 + (i * 60), width: 200,  height: height))
                    member.resvStatus?.drawIn(          CGRect(x: 3025, y: 705 + (i * 60), width: 200,  height: height))
                    
                }
            }
        }
        
        return backOfForm
    }
}

fileprivate extension Numeric {
    func drawIn(_ rect: CGRect){
        guard UIGraphicsGetCurrentContext() != nil else {
            return
            
        }
        
        let standardAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 36)]
        
        let s = NSAttributedString(string: "\(self)" , attributes: standardAttributes)
        s.draw(with: rect , options: .usesLineFragmentOrigin, context: nil)
    }
}

fileprivate extension String {
    func drawIn(_ rect: CGRect){
        guard UIGraphicsGetCurrentContext() != nil else {
            return
            
        }
        
        let standardAttributes: [NSAttributedString.Key: Any] = [ .font: UIFont.systemFont(ofSize: 36)]
        
        let s = NSAttributedString(string: self , attributes: standardAttributes)
        s.draw(with: rect , options: .usesLineFragmentOrigin, context: nil)
    }
}
