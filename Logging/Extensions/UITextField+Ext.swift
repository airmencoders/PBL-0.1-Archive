//
//  UITextField+Ext.swift
//  Logging
//
//  Created by John Bethancourt on 12/20/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

extension UITextField{
    func highlightRed() {
        self.layer.borderColor = UIColor.red.cgColor
    }
    
    func removeHighlight() {
        let color: UIColor = .fog
        self.layer.borderColor = color.cgColor
    }
    
    func highlightRedIfBlank() {
        if self.text == "" {
            self.highlightRed()
        } else {
            self.removeHighlight()
        }
    }
    
}

