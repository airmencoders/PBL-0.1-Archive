//
//  SideMenuViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/11/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func hideMenuButtonTapped()
    func overviewButtonTapped()
    func missionDataButtonTapped()
}

class SideMenuViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var overviewButton: PBLSideMenuButton!
    @IBOutlet weak var missionDataButton: PBLSideMenuButton!
    
    // MARK: - Properties
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Actions
    
    @IBAction func hideMenuButtonTapped(_ sender: UIButton) {
        delegate?.hideMenuButtonTapped()
    }
    
    @IBAction func overviewButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        overviewButton.isSelected = true
        updateButtons()
        delegate?.overviewButtonTapped()
    }
    
    @IBAction func missionDataButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        missionDataButton.isSelected = true
        updateButtons()
        delegate?.missionDataButtonTapped()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        overviewButton.isSelected = true
        updateButtons()
    }
    
    func updateButtons() {
        overviewButton.isSelected ? overviewButton.buttonSelected() : overviewButton.buttonNotSelected()
        missionDataButton.isSelected ? missionDataButton.buttonSelected() : missionDataButton.buttonNotSelected()
    }
    
    func deselectAllButtons() {
        overviewButton.isSelected = false
        missionDataButton.isSelected = false
    }
    
} //End