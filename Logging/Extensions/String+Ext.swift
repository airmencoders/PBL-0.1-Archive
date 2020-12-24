//
//  String+Ext.swift
//  Logging
//
//  Created by John Bethancourt on 12/20/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

infix operator +^+

extension String{
    
    /// No pleasant way to name this as a function:
    /// e.g. convertStringsToIntegersAndReturnSumAsString(string1 , string2)
    /// so I figured an infix operator would be the cleanest way
    /// I believe totalField.text = landCount1 +^+ landCount2 reads cleaner than:
    /// totalField.text = Utilities.addStringsAndReturnString(landCount1, landCount2)
    static func +^+(lhs: String, rhs: String) -> String {
        guard let lhs = Int(lhs) else { return "0" }
        guard let rhs = Int(rhs) else { return "0" }
        return "\(lhs + rhs)"
    }
    
    func isExactlyFourCharacters() -> Bool{
        return self.count == 4
    }
    
    var isDigits: Bool {
        guard self.count > 0 else { return false }
        let digits = Set("0123456789")
        return Set(self).isSubset(of: digits)
    }
    
}
