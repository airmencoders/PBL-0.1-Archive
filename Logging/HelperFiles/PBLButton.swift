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
    
    //TO DO: This needs to be adjusted for whether the app is started in portrait or landscape
    let buttonHeight = UIScreen.main.bounds.height/21.3
    let buttonPadding = UIScreen.main.bounds.width/41
    let fontSize = UIScreen.main.bounds.height/68.3
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        print("Screen height: \(UIScreen.main.bounds.height)")
//        print("Screen width: \(UIScreen.main.bounds.width)")
//        print("Button height: \(UIScreen.main.bounds.height/21.3)")
//        print("Button font size: \(UIScreen.main.bounds.height/68.3)")
        
        ///Divided by 21.3 because that is aproximately 64px in height for the 12.9in ipad
        self.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        self.frame.size.height = buttonHeight
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: buttonPadding, bottom: 0, right: buttonPadding)
        self.addCornerRadius(self.frame.size.height/2)
        self.backgroundColor = .fog
        self.tintColor = .clear
        self.titleLabel?.font = UIFont(name: FontNames.dmSansBold, size: fontSize)
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
