//
//  Flight+CoreDataClass.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

/*
 From: AFTO Form 781 descriptions and inputs

 6      flightSeq
 7      missionNumber       20 character alpha numeric          default from previous
 8      missionSymbol       4 character alpha numeric
 9      fromICAO            4 letter civil aviation code        dropdown - too much data, possibly remember frequently/previously used entries,
                                                                should allow for other characters
 10     toICAO              4 letter civil aviation code        should allow for other characters
 11     takeOffTime         (Z)                                 can cross z day
 12     landTime            (Z)
 13     totalTime           sum of blocks 11+12                 math added automatically, convert to decimal hours
 14     totalLandings       how many times plane landed         touch and go + full stop = total
 15     sorties             # of sorties flown                  almost always equals 1
 16     specialUse          gear cycles for locals              usually blank

 ATTN: No description for:
 touchAndGo
 fullStop
 */

import UIKit
import CoreData

@objc(Flight)
public class Flight: NSManagedObject {

    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public init?(flightSeq: String,
         missionNumber: String,
         missionSymbol: String,
         fromICAO: String,
         toICAO: String,
         takeOffTime: String,
         landTime: String,
         totalTime: String,
         touchAndGo: String,
         fullStop: String,
         totalLandings: String,
         sorties: String,
         specialUse: String) {

        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let Context = context else {
            return nil
        }
        guard let entitiyDesc = NSEntityDescription.entity(forEntityName: "Flight", in: Context) else {
            return nil
        }
        super.init(entity: entitiyDesc, insertInto: context)

        self.flightSeq = flightSeq
        self.missionNumber = missionNumber
        self.missionSymbol = missionSymbol
        self.fromICAO = fromICAO
        self.toICAO = toICAO
        self.takeOffTime = takeOffTime
        self.landTime = landTime
        self.totalTime = totalTime
        self.touchAndGo = touchAndGo
        self.fullStop = fullStop
        self.totalLandings = totalLandings
        self.sorties = sorties
        self.specialUse = specialUse
    }
}

extension Flight {  //: Equatable {
    
    #warning("make sure it equals what we want it to")
    static func ==(lhs: Flight, rhs: Flight) -> Bool {
        return (lhs.missionNumber == rhs.missionNumber)
    }
    
}
