//
//  PBLTextField.swift
//  Logging
//
//  Created by Bethany Morris on 10/15/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class PBLTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.borderStyle = .line
        //self.frame.size.height = UIScreen.main.bounds.height/17.1
        self.font = UIFont(name: FontNames.dmSansBold, size: UIScreen.main.bounds.height/56.9)
        self.textColor = .slate
        self.backgroundColor = .white
        self.addAccentBorder()
        self.textAlignment = .left
        self.autocapitalizationType = .allCharacters
        self.autocorrectionType = .no
    }
    
    #warning("set up placeholder font?")
    
    let padding = UIEdgeInsets(top: UIScreen.main.bounds.height/90, left: UIScreen.main.bounds.width/41, bottom: UIScreen.main.bounds.height/90, right: UIScreen.main.bounds.width/41)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
