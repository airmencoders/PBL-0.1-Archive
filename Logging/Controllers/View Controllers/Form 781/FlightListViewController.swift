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
    
    @IBOutlet weak var aircrewListView: UIView!
    @IBOutlet weak var missionDataView: UIView!
    @IBOutlet weak var aircrewDataView: UIView!
    
    // MARK: - Properties
    
    var takeOffTimeString: String = " "
    var landTimeString: String = " "
    
    // MARK: - Local variables
    private var saveddateTextFieldText: String = ""

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        loadFromData()
        //disableButtons()
        guard let form = Form781Controller.shared.forms.last else { return }
        missionDateLabel.text = "MISSION \(form.date)"
    }
    
    func loadFromData(){
        do {
            try Form781Controller.shared.loadForms()
        } catch {
            NSLog("\(Form781Error.FileNotFound)")
        }
        
//        let form = Form781Controller.shared.forms.last
//        if Helper.checkForFile(filePath: Form781Controller.shared.fileURL()){
//            dateTextField.text = form?.date
//            mdsTextField.text = form?.mds
//            serialNumTextField.text = form?.serialNumber
//            unitChargedTextField.text = form?.unitCharged
//            harmLocationTextField.text = form?.harmLocation
//            flightAuthTextField.text = form?.flightAuthNum
//            issuingUnitTextField.text = form?.issuingUnit
//        } else {
//            dateTextField.text = Helper.getTodaysDate()
//        }
    }
    
    //disable and enable within container views (popUp)
    func disableButtons() {
        printButton.isUserInteractionEnabled = false
        backButton.isUserInteractionEnabled = false
        continueButton.isUserInteractionEnabled = false
    }
    
    func enableButtons() {
        printButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        continueButton.isUserInteractionEnabled = true
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
