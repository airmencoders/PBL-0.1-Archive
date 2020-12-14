//
//  WelcomeViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/20/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // MARK: - Methods & Actions
    
    func toggleButton(sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .slate
            sender.setTitleColor(.white, for: .normal)
        } else {
            sender.backgroundColor = .mist
            sender.setTitleColor(.slate, for: .normal)
        }
    }
    
    @IBAction func form781Tapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func fuelTrackerTapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func form1881Tapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func form2131Tapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func form97Tapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func form1081Tapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func ormMissionTapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func ormLocalTapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func moreFormsButtonTapped(_ sender: UIButton) {
        toggleButton(sender: sender)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Form781", bundle: nil).instantiateViewController(withIdentifier: "FlightList") as? Form781ViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
} //End
