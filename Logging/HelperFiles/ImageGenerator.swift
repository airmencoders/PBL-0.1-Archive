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
    /**
     - The generateFrontOfForm function is used to pull the data written in our JSON file and overlay it on an image of the front of the xAFTO Form 781.

     - Parameter none: All data is being retrieved from the stored JSON.

     - Throws: none

     - Returns: An image that can be rendered with the printController.
     
        throughout the function, any hard coded numbers represent pixels on the underlay image.  We use an NSAttributedString which gives the ability to control the font size.  Then we use the draw function to position it on the page.
     */

    static func generateFrontOfForm() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Helper.WIDTH, height: Helper.HEIGHT))
        
        let img = renderer.image { ctx in
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36)
            ]
            
            // MARK: - Section 1
            let form = Form781Controller.shared.getCurrentForm()
            
            let dateString = NSAttributedString(string: form?.date ?? " ", attributes: attrs)
            dateString.draw(with: CGRect(x: 250, y: 245, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let mdsString = NSAttributedString(string: form?.mds ?? " ", attributes: attrs)
            mdsString.draw(with: CGRect(x: 700, y: 245, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let serialNumberString = NSAttributedString(string: form?.serialNumber ?? " ", attributes: attrs)
            serialNumberString.draw(with: CGRect(x: 1035, y: 245, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let unitChargedString = NSAttributedString(string: form?.unitCharged ?? " ", attributes: attrs)
            unitChargedString.draw(with: CGRect(x: 1390, y: 245, width: 500, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let harmLocationString = NSAttributedString(string: form?.harmLocation ?? " ", attributes: attrs)
            harmLocationString.draw(with: CGRect(x: 2120, y: 245, width: 980, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let flightAuthString = NSAttributedString(string: form?.flightAuthNum ?? " ", attributes: attrs)
            flightAuthString.draw(with: CGRect(x: 545, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let issuingUnitString = NSAttributedString(string: form?.issuingUnit ?? " ", attributes: attrs)
            issuingUnitString.draw(with: CGRect(x: 1085, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalTimeString = NSAttributedString(string: "\(form?.grandTotalTime ?? 0)", attributes: attrs)
            grandTotalTimeString.draw(with: CGRect(x: 1875, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalTandGString = NSAttributedString(string: "\(form?.grandTotalTouchAndGo ?? 0)", attributes: attrs)
            grandTotalTandGString.draw(with: CGRect(x: 2060, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalFullStopString = NSAttributedString(string: "\(form?.grandTotalFullStop ?? 0)", attributes: attrs)
            grandTotalFullStopString.draw(with: CGRect(x: 2200, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalLandingString = NSAttributedString(string: "\(form?.grandTotalLandings ?? 0)", attributes: attrs)
            grandTotalLandingString.draw(with: CGRect(x: 2310, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            let grandTotalSoritesString = NSAttributedString(string: "\(form?.grandTotalSorties ?? 0)", attributes: attrs)
            grandTotalSoritesString.draw(with: CGRect(x: 2490, y: 820, width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
            
            // MARK: - Flight Sequence
            if Form781Controller.shared.getCurrentForm()?.flights.count ?? 0 > 0 {
                for x in 0...(form!.flights.count - 1){
                    let msnNumberString = NSAttributedString(string: form?.flights[x].missionNumber ?? " ", attributes: attrs)
                    msnNumberString.draw(with: CGRect(x: 345, y: 455 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let msnSymbolString = NSAttributedString(string: form?.flights[x].missionSymbol ?? " ", attributes: attrs)
                    msnSymbolString.draw(with: CGRect(x: 825, y: 455 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let fromICAOString = NSAttributedString(string: form?.flights[x].fromICAO ?? " ", attributes: attrs)
                    fromICAOString.draw(with: CGRect(x: 1045, y: 455 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let toICAOString = NSAttributedString(string: form?.flights[x].toICAO ?? " ", attributes: attrs)
                    toICAOString.draw(with: CGRect(x: 1265, y: 455 + (x * 65), width: 300, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let toTime = NSAttributedString(string: form?.flights[x].takeOffTime ?? " ", attributes: attrs)
                    toTime.draw(with: CGRect(x: 1465, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let landTime = NSAttributedString(string: form?.flights[x].landTime ?? " ", attributes: attrs)
                    landTime.draw(with: CGRect(x: 1680, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let totalTime = NSAttributedString(string: form?.flights[x].totalTime ?? " ", attributes: attrs)
                    totalTime.draw(with: CGRect(x: 1875, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let touchAndGo = NSAttributedString(string: form?.flights[x].touchAndGo ?? " ", attributes: attrs)
                    touchAndGo.draw(with: CGRect(x: 2060, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let fullStop = NSAttributedString(string: form?.flights[x].fullStop ?? " ", attributes: attrs)
                    fullStop.draw(with: CGRect(x: 2200, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let totalLanding = NSAttributedString(string: form?.flights[x].totalLandings ?? " ", attributes: attrs)
                    totalLanding.draw(with: CGRect(x: 2310, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let sorties = NSAttributedString(string: form?.flights[x].sorties ?? " ", attributes: attrs)
                    sorties.draw(with: CGRect(x: 2490, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let specialUse = NSAttributedString(string: form?.flights[x].specialUse ?? " ", attributes: attrs)
                    specialUse.draw(with: CGRect(x: 2590, y: 455 + (x * 65), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                }
            }
            
            
            
            // MARK: - AirCrew
            // Section 2
            
            // I need to determine if the crew count exceeds the number of rows on the front of the form.
            
            
            if form!.crewMembers.count > 0 {
                let crewSize: Int = form!.crewMembers.count
                if crewSize <= 15 {
                    for x in 0...crewSize - 1 {
                        let orgString = NSAttributedString(string: form?.crewMembers[x].flyingOrigin ?? " ", attributes: attrs)
                        orgString.draw(with: CGRect(x: 175, y: 1085 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let last4String = NSAttributedString(string: form?.crewMembers[x].ssnLast4 ?? " ", attributes: attrs)
                        last4String.draw(with: CGRect(x: 315, y: 1085 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let lastNameString = NSAttributedString(string: form?.crewMembers[x].lastName ?? " ", attributes: attrs)
                        lastNameString.draw(with: CGRect(x: 455, y: 1085 + (x * 60), width: 505, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let flightAuthCodeString = NSAttributedString(string: form?.crewMembers[x].flightAuthDutyCode ?? " ", attributes: attrs)
                        flightAuthCodeString.draw(with: CGRect(x: 1035, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let primaryString = NSAttributedString(string: form?.crewMembers[x].primary ?? " ", attributes: attrs)
                        primaryString.draw(with: CGRect(x: 1130, y: 1085 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let secString = NSAttributedString(string: form?.crewMembers[x].secondary ?? " ", attributes: attrs)
                        secString.draw(with: CGRect(x: 1240, y: 1085 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let instString = NSAttributedString(string: form?.crewMembers[x].instructor ?? " ", attributes:  attrs)
                        instString.draw(with: CGRect(x: 1355, y: 1085 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let evalString = NSAttributedString(string: form?.crewMembers[x].evaluator ?? " ", attributes: attrs)
                        evalString.draw(with: CGRect(x: 1670, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let otherString = NSAttributedString(string: form?.crewMembers[x].other ?? " ", attributes: attrs)
                        otherString.draw(with: CGRect(x: 1790, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let timeTotalString = NSAttributedString(string: form?.crewMembers[x].time ?? " ", attributes: attrs)
                        timeTotalString.draw(with: CGRect(x: 1905, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let sortyTotalString = NSAttributedString(string: form?.crewMembers[x].srty ?? " ", attributes: attrs)
                        sortyTotalString.draw(with: CGRect(x: 2015, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let nightString = NSAttributedString(string: form?.crewMembers[x].nightPSIE ?? " ", attributes: attrs)
                        nightString.draw(with: CGRect(x: 2160, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let insPIEString = NSAttributedString(string: form?.crewMembers[x].insPIE ?? " ", attributes: attrs)
                        insPIEString.draw(with: CGRect(x: 2280, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let simInsString = NSAttributedString(string: form?.crewMembers[x].simIns ?? " ", attributes: attrs)
                        simInsString.draw(with: CGRect(x: 2300, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let nvgString = NSAttributedString(string: form?.crewMembers[x].nvg ?? " ", attributes: attrs)
                        nvgString.draw(with: CGRect(x: 2415, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let cbtTimeString = NSAttributedString(string: form?.crewMembers[x].combatTime ?? " ", attributes: attrs)
                        cbtTimeString.draw(with: CGRect(x: 2530, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let cbtSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSrty ?? " ", attributes: attrs)
                        cbtSrtyString.draw(with: CGRect(x: 2630, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let cbtSptTimeString = NSAttributedString(string: form?.crewMembers[x].combatSptTime ?? " ", attributes: attrs)
                        cbtSptTimeString.draw(with: CGRect(x: 2730, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let cbtSptSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSptSrty ?? " ", attributes: attrs)
                        cbtSptSrtyString.draw(with: CGRect(x: 2840, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                        
                        let resvStatusString = NSAttributedString(string: form?.crewMembers[x].resvStatus ?? " ", attributes: attrs)
                        resvStatusString.draw(with: CGRect(x: 2940, y: 1085 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    }
                } else {
                    for x in 0...14 {
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
    static func generateBackOfForm() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: Helper.WIDTH, height: Helper.HEIGHT))
        
        let backOfForm = renderer.image { ctx in
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36)
            ]
            
            // MARK: - Crew finsihing
            let form = Form781Controller.shared.getCurrentForm()
            
            let crewSize:Int = (form?.crewMembers.count)!
            
            if crewSize >= 15 {
                let remainingCrew = crewSize - 15
                for x in 0...remainingCrew {
                    let orgString = NSAttributedString(string: form?.crewMembers[x].flyingOrigin ?? " ", attributes: attrs)
                    orgString.draw(with: CGRect(x: 310, y: 705 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let last4String = NSAttributedString(string: form?.crewMembers[x].ssnLast4 ?? " ", attributes: attrs)
                    last4String.draw(with: CGRect(x: 450, y: 705 + (x * 60), width: 100, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let lastNameString = NSAttributedString(string: form?.crewMembers[x].lastName ?? " ", attributes: attrs)
                    lastNameString.draw(with: CGRect(x: 580, y: 705 + (x * 60), width: 505, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let flightAuthCodeString = NSAttributedString(string: form?.crewMembers[x].flightAuthDutyCode ?? " ", attributes: attrs)
                    flightAuthCodeString.draw(with: CGRect(x: 1115, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let primaryString = NSAttributedString(string: form?.crewMembers[x].primary ?? " ", attributes: attrs)
                    primaryString.draw(with: CGRect(x: 1365, y: 705 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let secString = NSAttributedString(string: form?.crewMembers[x].secondary ?? " ", attributes: attrs)
                    secString.draw(with: CGRect(x: 1475, y: 705 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let instString = NSAttributedString(string: form?.crewMembers[x].instructor ?? " ", attributes:  attrs)
                    instString.draw(with: CGRect(x: 1590, y: 705 + (x * 60), width: 50, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let evalString = NSAttributedString(string: form?.crewMembers[x].evaluator ?? " ", attributes: attrs)
                    evalString.draw(with: CGRect(x: 1705, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let otherString = NSAttributedString(string: form?.crewMembers[x].other ?? " ", attributes: attrs)
                    otherString.draw(with: CGRect(x: 1825, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let timeTotalString = NSAttributedString(string: form?.crewMembers[x].time ?? " ", attributes: attrs)
                    timeTotalString.draw(with: CGRect(x: 1940, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let sortyTotalString = NSAttributedString(string: form?.crewMembers[x].srty ?? " ", attributes: attrs)
                    sortyTotalString.draw(with: CGRect(x: 2050, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let nightString = NSAttributedString(string: form?.crewMembers[x].nightPSIE ?? " ", attributes: attrs)
                    nightString.draw(with: CGRect(x: 2145, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let insPIEString = NSAttributedString(string: form?.crewMembers[x].insPIE ?? " ", attributes: attrs)
                    insPIEString.draw(with: CGRect(x: 2265, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let simInsString = NSAttributedString(string: form?.crewMembers[x].simIns ?? " ", attributes: attrs)
                    simInsString.draw(with: CGRect(x: 2385, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let nvgString = NSAttributedString(string: form?.crewMembers[x].nvg ?? " ", attributes: attrs)
                    nvgString.draw(with: CGRect(x: 2500, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtTimeString = NSAttributedString(string: form?.crewMembers[x].combatTime ?? " ", attributes: attrs)
                    cbtTimeString.draw(with: CGRect(x: 2615, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSrty ?? " ", attributes: attrs)
                    cbtSrtyString.draw(with: CGRect(x: 2715, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSptTimeString = NSAttributedString(string: form?.crewMembers[x].combatSptTime ?? " ", attributes: attrs)
                    cbtSptTimeString.draw(with: CGRect(x: 2815, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let cbtSptSrtyString = NSAttributedString(string: form?.crewMembers[x].combatSptSrty ?? " ", attributes: attrs)
                    cbtSptSrtyString.draw(with: CGRect(x: 2925, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                    
                    let resvStatusString = NSAttributedString(string: form?.crewMembers[x].resvStatus ?? " ", attributes: attrs)
                    resvStatusString.draw(with: CGRect(x: 3025, y: 705 + (x * 60), width: 200, height: 50), options: .usesLineFragmentOrigin, context: nil)
                }
            }
        }
        
        return backOfForm
    }
}
