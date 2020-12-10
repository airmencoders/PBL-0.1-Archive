//
//  Flight+CoreDataClass.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

import UIKit
import CoreData

@objc(Flight)
public class Flight: NSManagedObject {

    public init(flightSeq: String,
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

//        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
//        guard let Context = context else {
//            return nil
//        }
//        guard let entitiyDesc = NSEntityDescription.entity(forEntityName: "CrewMember", in: Context) else {
//            return nil
//        }
//        super.init(entity: entitiyDesc, insertInto: context)

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

extension Flight: Equatable {
    
    #warning("make sure it equals what we want it to")
    static func ==(lhs: Flight, rhs: Flight) -> Bool {
        return (lhs.missionNumber == rhs.missionNumber)
    }
    
}
