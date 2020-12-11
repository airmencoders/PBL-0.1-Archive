//
//  MainViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/11/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var form781View: UIView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func showMenuButtonTapped(_ sender: UIButton) {
        sideMenuView.isHidden = false
    }
    
} //End

// MARK: - Delegates

extension MainViewController: SideMenuViewControllerDelegate {
    
    func hideMenuButtonTapped() {
        sideMenuView.isHidden = true
    }
    
    func overviewButtonTapped() {
        overviewView.isHidden = false
        form781View.isHidden = true
    }
    
    func missionDataButtonTapped() {
        form781View.isHidden = false
        overviewView.isHidden = true
    }
    
    func aircrewListButtonTapped() {
        form781View.isHidden = false
        overviewView.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSideMenuVC" {
            guard let destinationVC = segue.destination as? SideMenuViewController else {
                return
            }
            destinationVC.delegate = self
        }
    }
    
} //End
