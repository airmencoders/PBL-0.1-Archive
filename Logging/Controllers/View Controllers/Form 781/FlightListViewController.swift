//
//  FlightListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/27/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit
import Foundation

class FlightListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var missionDateLabel: UILabel!
    @IBOutlet weak var formSegmentedControl: UISegmentedControl!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var aircrewListView: UIView!
    @IBOutlet weak var missionDataView: UIView!
    @IBOutlet weak var aircrewDataView: UIView!
    
    // MARK: - Properties
    
    var firstTimeToMissionData = true

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return
        }
        missionDateLabel.text = "MISSION \(form.date)"
    }

    // MARK: - Actions
    
    @IBAction func formSegmentedControlChanged(_ sender: UISegmentedControl) {
        switch formSegmentedControl.selectedSegmentIndex {
        case 0:
            aircrewListView.isHidden = false
            missionDataView.isHidden = true
            aircrewDataView.isHidden = true
        case 1:
            aircrewListView.isHidden = true
            missionDataView.isHidden = false
            aircrewDataView.isHidden = true
            if firstTimeToMissionData {
                dimView.isHidden = false
                firstTimeToMissionData = false
            }
        case 2:
            aircrewListView.isHidden = true
            missionDataView.isHidden = true
            aircrewDataView.isHidden = false
        default:
            aircrewListView.isHidden = false
            missionDataView.isHidden = true
            aircrewDataView.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {

    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        // resign first responder in container view
    }
    
} //End

extension FlightListViewController: AircrewViewControllerDelegate, MissionDataViewControllerDelegate {
    func updateDimView(toHidden: Bool) {
        toHidden ? (dimView.isHidden = true) : (dimView.isHidden = false)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAircrewVC" {
            guard let destinationVC = segue.destination as? AircrewViewController else {
                return
            }
            destinationVC.delegate = self
        }
        if segue.identifier == "ToMissionDataVC" {
            guard let destinationVC = segue.destination as? MissionDataViewController else {
                return
            }
            destinationVC.delegate = self
        }
    }
    
} //End
