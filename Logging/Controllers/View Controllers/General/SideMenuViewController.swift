//
//  SideMenuViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/11/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func menuButtonTapped(isOpen: Bool)
    func overviewButtonTapped()
    func missionDataButtonTapped()
    func aircrewListButtonTapped()
    func aircrewDataButtonTapped()
}

class SideMenuViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var overviewButton: PBLSideMenuButton!
    @IBOutlet weak var missionDataButton: PBLSideMenuButton!
    @IBOutlet weak var aircrewListButton: PBLSideMenuButton!
    @IBOutlet weak var aircrewDataButton: PBLSideMenuButton!
    @IBOutlet weak var daysTableView: UITableView!
    
    // MARK: - Properties
    
    weak var delegate: SideMenuViewControllerDelegate?
    var isMenuOpen = true
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        overviewButton.isSelected = true
        updateButtons()
    }
    
    func updateButtons() {
        overviewButton.isSelected ? overviewButton.updateUI(toSelected: true) : overviewButton.updateUI(toSelected: false)
        missionDataButton.isSelected ? missionDataButton.updateUI(toSelected: true) : missionDataButton.updateUI(toSelected: false)
        aircrewListButton.isSelected ? aircrewListButton.updateUI(toSelected: true) : aircrewListButton.updateUI(toSelected: false)
        aircrewDataButton.isSelected ? aircrewDataButton.updateUI(toSelected: true) : aircrewDataButton.updateUI(toSelected: false)
    }
    
    func deselectAllButtons() {
        overviewButton.isSelected = false
        missionDataButton.isSelected = false
        aircrewListButton.isSelected = false
        aircrewDataButton.isSelected = false
    }
    
    func updateButtonVisibility(toHidden: Bool) {
        overviewButton.isHidden = toHidden
        missionDataButton.isHidden = toHidden
        aircrewListButton.isHidden = toHidden
        aircrewDataButton.isHidden = toHidden
        daysTableView.isHidden = toHidden
    }
    
    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        isMenuOpen.toggle()
        delegate?.menuButtonTapped(isOpen: isMenuOpen)
        if isMenuOpen {
            menuButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            updateButtonVisibility(toHidden: false)
        } else {
            menuButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            updateButtonVisibility(toHidden: true)
        }
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
    
    @IBAction func aircrewListButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        aircrewListButton.isSelected = true
        updateButtons()
        delegate?.aircrewListButtonTapped()
    }
    
    @IBAction func aircrewDataButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        aircrewDataButton.isSelected = true
        updateButtons()
        delegate?.aircrewDataButtonTapped()
    }
    
} //End
