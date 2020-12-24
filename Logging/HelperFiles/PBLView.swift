//
//  PBLView.swift
//  Logging
//
//  Created by Bethany Morris on 10/15/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class PBLView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mist
    }
}

class popUpView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mist
    }
}

class daysView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .haze
        self.addCornerRadius()
    }
}
