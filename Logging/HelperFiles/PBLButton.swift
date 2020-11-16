//
//  PBLButton.swift
//  Logging
//
//  Created by Bethany Morris on 10/9/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class PBLButtonClear: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.setTitleColor(.slate, for: .normal)
        self.updateFont(to: FontNames.dmSansBold)
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        //self.titleLabel?.adjustsFontForContentSizeCategory = true
    }
    
    func updateFont(to font: String) {
        guard let size = self.titleLabel?.font.pointSize else { return }
        self.titleLabel?.font = UIFont(name: font, size: size)
    }
    
}

class PBLButton: PBLButtonClear {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        //self.frame.size.height = 64
        print(UIScreen.main.bounds)
        self.heightAnchor.constraint(equalToConstant: 64.0).isActive = true
        self.frame.size.height = 64
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.addCornerRadius(self.frame.size.height/2)
        self.backgroundColor = .fog
        self.tintColor = .clear
    }
        
}

class PBLButtonDark: PBLButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .slate
        self.setTitleColor(.white, for: .normal)
    }
    
}

class PBLButtonLight: PBLButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mist
        self.setTitleColor(.slate, for: .normal)
    }
    
}

class PBLOverviewButton: PBLButtonClear {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .mist
        self.setTitleColor(.slate, for: .normal)
        self.tintColor = .slate
        self.contentHorizontalAlignment = .left
        self.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 0)
        
        self.layer.shadowColor = UIColor.fog.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 2
    }
    
}
