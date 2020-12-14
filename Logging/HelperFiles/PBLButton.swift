//
//  PBLButton.swift
//  Logging
//
//  Created by Bethany Morris on 10/9/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

//12.9in iPad Pro has screen height of 1366 and width of 1024

class PBLButtonClear: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.setTitleColor(.slate, for: .normal)
        self.titleLabel?.font = UIFont(name: FontNames.dmSansRegular, size: 24)
    }
}

class PBLButton: PBLButtonClear {
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print("Screen height: \(UIScreen.main.bounds.height)")
//        print("Screen width: \(UIScreen.main.bounds.width)")
//        print("Button height: \(UIScreen.main.bounds.height/21.3)")
//        print("Button font size: \(UIScreen.main.bounds.height/68.3)")
        
        ///Divided by 21.3 because that is aproximately 64px in height for the 12.9in ipad
        self.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/21.3).isActive = true
        self.frame.size.height = UIScreen.main.bounds.height/21.3
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width/41, bottom: 0, right: UIScreen.main.bounds.width/41)
        self.addCornerRadius(self.frame.size.height/2)
        self.backgroundColor = .fog
        self.tintColor = .clear
        self.titleLabel?.font = UIFont(name: FontNames.dmSansBold, size: UIScreen.main.bounds.height/68.3)
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
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 0)

//        self.layer.shadowColor = UIColor.fog.cgColor
//        self.layer.shadowOpacity = 1
//        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        self.layer.shadowRadius = 2
    }
}

class PBLIconButton: PBLButtonClear {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.font = UIFont(name: FontNames.dmSansBold, size: UIScreen.main.bounds.height/97.6)
    }
}

class PBLIconButtonWhite: PBLIconButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTitleColor(.white, for: .normal)
    }
}

class PBLSideMenuButton: PBLOverviewButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .haze
        self.titleLabel?.font = UIFont(name: FontNames.dmSansBold, size: 14)
        addCornerRadius()
    }
    
    func updateUI(toSelected: Bool) {
        if toSelected {
            self.backgroundColor = .slate
            self.setTitleColor(.white, for: .normal)
        } else {
            self.backgroundColor = .haze
            self.setTitleColor(.slate, for: .normal)
        }
    }

}
