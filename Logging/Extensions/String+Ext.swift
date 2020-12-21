//
//  String+Ext.swift
//  Logging
//
//  Created by John Bethancourt on 12/20/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

extension String{
    
    func isExactlyFourCharacters() -> Bool{
        return self.count == 4
    }
    
    var isDigits: Bool {
        guard self.count > 0 else { return false }
        let digits = Set("0123456789")
        return Set(self).isSubset(of: digits)
    }
    
}
