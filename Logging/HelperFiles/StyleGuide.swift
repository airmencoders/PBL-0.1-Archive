//
//  StyleGuide.swift
//  Logging
//
//  Created by Bethany Morris on 10/9/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

extension UIView {
    
    func addCornerRadius(_ radius: CGFloat = 5) {
        self.layer.cornerRadius = radius
    }
    
    func addAccentBorder(width: CGFloat = 1, color: UIColor = .fog) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
}

extension UIColor {
    
    static let notBlack = UIColor(named: "notBlack")!
    static let slate = UIColor(named: "slate")!
    static let fog = UIColor(named: "fog")!
    static let haze = UIColor(named: "haze")!
    static let mist = UIColor(named: "mist")!
    static let PBLGray = UIColor(named: "PBLGray")

}

struct FontNames {
    
    static let dmSansRegular = "DMSans-Regular"
    static let dmSansMedium = "DMSans-Medium"
    static let dmSansBold = "DMSans-Bold"
    
}
