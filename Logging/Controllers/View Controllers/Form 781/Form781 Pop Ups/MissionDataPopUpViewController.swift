//
//  MissionDataPopUpViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/16/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol MissionDataPopUpViewControllerDelegate: class {
    func closeMissionDataPopUp()
}

class MissionDataPopUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mdsTextField: UITextField!
    @IBOutlet weak var serialNumTextField: UITextField!
    @IBOutlet weak var unitChargedTextField: UITextField!
    @IBOutlet weak var harmLocationTextField: UITextField!
    @IBOutlet weak var flightAuthTextField: UITextField!
    @IBOutlet weak var issuingUnitTextField: UITextField!
    
    // MARK: - Properties
    
    weak var delegate: MissionDataPopUpViewControllerDelegate?
    private var savedDateTextFieldText: String = ""
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        dateTextField.delegate = self
        mdsTextField.delegate = self
        serialNumTextField.delegate = self
        unitChargedTextField.delegate = self
        harmLocationTextField.delegate = self
        flightAuthTextField.delegate = self
        issuingUnitTextField.delegate = self
    }
    
    func reloadCurrentFormViews() {
        let form = Form781Controller.shared.getCurrentForm()
        if Utilities.doesFileExist(atURL: Form781Controller.shared.fileURL(filename: Form781Controller.shared.loggingFileName)){
            dateTextField.text = form?.date
            mdsTextField.text = form?.mds
            serialNumTextField.text = form?.serialNumber
            unitChargedTextField.text = form?.unitCharged
            harmLocationTextField.text = form?.harmLocation
            flightAuthTextField.text = form?.flightAuthNum
            issuingUnitTextField.text = form?.issuingUnit
        } else {
            dateTextField.text = Date().AFTOForm781String()
        }
    }
    
    func presentAlertIfMissionInputError() {
        guard let date = dateTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() dateTextField.text undefined.")
            return
        }
        guard let mds = mdsTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() mdsTextField.text undefined.")
            return
        }
        guard let serialNumber = serialNumTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() serialNumTextField.text undefined.")
            return
        }
        guard let unitCharged = unitChargedTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() unitChargedTextField.text undefined.")
            return
        }
        guard let harmLocation = harmLocationTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() harmLocationTextField.text undefined.")
            return
        }
        guard let flightAuthNum = flightAuthTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() flightAuthTextField.text undefined.")
            return
        }
        guard let issuingUnit = issuingUnitTextField.text else {
            NSLog("ERROR: MissionDataViewController: presentAlertIfMissionInputError() issuingUnitTextField.text undefined.")
            return
        }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            Form781Controller.shared.updateMissionData(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
            
            self.closePopUp()
        }
    }
    
    
    func highlightMissionData() {
        dateTextField.highlightRedIfBlank()
        mdsTextField.highlightRedIfBlank()
        serialNumTextField.highlightRedIfBlank()
        unitChargedTextField.highlightRedIfBlank()
        harmLocationTextField.highlightRedIfBlank()
        flightAuthTextField.highlightRedIfBlank()
        issuingUnitTextField.highlightRedIfBlank()
        
    }
    
    func unhighlight() {
        dateTextField.removeAnyColorHighlight()
        mdsTextField.removeAnyColorHighlight()
        serialNumTextField.removeAnyColorHighlight()
        unitChargedTextField.removeAnyColorHighlight()
        harmLocationTextField.removeAnyColorHighlight()
        flightAuthTextField.removeAnyColorHighlight()
        issuingUnitTextField.removeAnyColorHighlight()
        
    }
    
    func closePopUp() {
        unhighlight()
        delegate?.closeMissionDataPopUp()
    }
    
    // MARK: - Actions
    
    @IBAction func saveMissionDataTapped(_ sender: UIButton) {
        highlightMissionData()
        #warning("Should we split this up? If *.text is nil this is some other error. If the item is empty, we handle it with presentAlertIfInputError().")
        guard let date = dateTextField.text, !date.isEmpty,
              let mds = mdsTextField.text, !mds.isEmpty,
              let serialNumber = serialNumTextField.text, !serialNumber.isEmpty,
              let unitCharged = unitChargedTextField.text, !unitCharged.isEmpty,
              let harmLocation = harmLocationTextField.text, !harmLocation.isEmpty,
              let flightAuthNum = flightAuthTextField.text, !flightAuthNum.isEmpty,
              let issuingUnit = issuingUnitTextField.text, !issuingUnit.isEmpty
        else {
            return presentAlertIfMissionInputError()
        }
        
        Form781Controller.shared.updateMissionData(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        
        closePopUp()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dateTextField.resignFirstResponder()
        mdsTextField.resignFirstResponder()
        serialNumTextField.resignFirstResponder()
        unitChargedTextField.resignFirstResponder()
        harmLocationTextField.resignFirstResponder()
        flightAuthTextField.resignFirstResponder()
        issuingUnitTextField.resignFirstResponder()
    }
    
} //End

// MARK: - UITextField Delegate

extension MissionDataPopUpViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.dateTextField {
            self.savedDateTextFieldText = self.dateTextField.text ?? ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.dateTextField {
            guard let dateString = textField.text else {
                textField.text = self.savedDateTextFieldText
                return
            }
            let date = Utilities.dateFromString(dateString)
            
            if let date = date {
                textField.text = date.AFTOForm781String()
            } else {
                textField.text = self.savedDateTextFieldText
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End

// MARK: - Delegates

extension MissionDataPopUpViewController: MainViewControllerMissionDataPopUpDelegate {
    func editMissionDataButtonTapped() {
        reloadCurrentFormViews()
    }
    
} //End
