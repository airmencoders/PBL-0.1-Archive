//
//  SplitTime.swift
//  Logging
//
//  Created by Pete Misik on 11/25/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation


class SplitTime {
    
    func loadMasters(numberOfCrew: Int, loggedTime: Float) -> Float{
        return loggedTime/Float(numberOfCrew)
        
    }
    
    func pilotSplit(numberOfCrew: Int, loggedTime: Float) -> Float {
        
        let fSplit = loggedTime/Float(numberOfCrew)
        
        let diffTime = fSplit * Float(numberOfCrew)
        
        if loggedTime - diffTime > 0.01{
        
            // Throw an alert about the remainder.
            NSLog("Fraction remaining")
        }
        
        return fSplit
    }
}
