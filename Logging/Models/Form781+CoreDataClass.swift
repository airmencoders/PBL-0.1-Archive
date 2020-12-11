//
//  Form781+CoreDataClass.swift
//  
//
//  Created by Pete Hoch on 12/10/20.
//
//

/*
 From: AFTO Form 781 descriptions and inputs

 1      date            01 Jan 2021                         calendar/dropdown, date is Z day, if mission starts new Z day then new form needed
 2      mds             mission design system               default from previous
                        type of plane (C017A) (SMC130E)
 3      serialNumber    (YY-T777)                           default from previous
                        tail # of individual plane
 4      unitCharged                                         text box/drop down with preconfigured thiings
 5      harmLocation    base location                       default from profile location but can be edited, could pull from serial #
 17     flightAuthNum   year-string of alpha numeric        default from previous
 18     issuingUnit     16th airlift sqadron
 --     grandTotalTime  sum of column                       automatically adds column above
 */

import UIKit
import CoreData

@objc(Form781)
public class Form781: NSManagedObject {

    override public init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }

    public init?(date: String,
                mds: String,
                serialNumber: String,
                unitCharged: String,
                harmLocation: String,
                flightAuthNum: String,
                issuingUnit: String,
                grandTotalTime: Double? = nil,
                grandTotalTouchAndGo: Int? = nil,
                grandTotalFullStop: Int? = nil,
                grandTotalStops: Int? = nil,
                grandTotalSorties: Int? = nil,
                flights: [Flight] = [],
                crewMembers: [CrewMember] = [])  {
 
        let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        guard let Context = context else {
            return nil
        }
        guard let entitiyDesc = NSEntityDescription.entity(forEntityName: "Form781", in: Context) else {
            return nil
        }
        super.init(entity: entitiyDesc, insertInto: context)

        self.date = date
        self.mds = mds
        self.serialNumber = serialNumber
        self.unitCharged = unitCharged
        self.harmLocation = harmLocation
        self.flightAuthNum = flightAuthNum
        self.issuingUnit = issuingUnit
        self.grandTotalTime = grandTotalTime ?? 0
        self.grandTotalTouchAndGo = Int32(grandTotalTouchAndGo ?? 0)
        self.grandTotalFullStop = Int32(grandTotalFullStop ?? 0)
        self.grandTotalLandings = Int32(grandTotalStops ?? 0)
        self.grandTotalSorties = Int32(grandTotalSorties ?? 0)
        
        for flight in flights {
            self.addToFlights(flight)
        }

        for crewMember in crewMembers {
            self.addToCrewMembers(crewMember)
        }
    }
}

extension Form781 {     //: Equatable {
    
    //make sure it equals what we want it to
    static func ==(lhs: Form781, rhs: Form781) -> Bool {
        return (lhs.serialNumber == rhs.serialNumber)
    }
    
}
