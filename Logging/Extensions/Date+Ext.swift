//
//  Date+Ext.swift
//  Logging
//
//  Created by John Bethancourt on 12/20/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation

extension Date {
    func AFTOFormFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.dateFormat
        return dateFormatter.string(from: self)
    }
}
