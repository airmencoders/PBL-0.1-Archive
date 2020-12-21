//
//  AircrewPopUpViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/15/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewPopUpViewControllerDelegate: class {
    func closeAircrewPopUp()
}

class AircrewPopUpViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var ssn: UITextField!
    @IBOutlet weak var flightAuthDutyCode: UITextField!
    @IBOutlet weak var flyingOranization: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    
    weak var delegate: AircrewPopUpViewControllerDelegate?
    var isEditingMember = false
    var crewMemberToEdit: CrewMember?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        lastName.delegate = self
        firstName.delegate = self
        ssn.delegate = self
        flightAuthDutyCode.delegate = self
        flyingOranization.delegate = self
    }
    
    func presentAlertIfInputError() {
        #warning("Why don't we post the error is the text field is undefined?")
        guard let lastName = lastName.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - lastName")
            return
        }
        guard let firstName = firstName.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - firstName")
            return
        }
        guard let ssn = ssn.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - ssn")
            return
        }
        guard let flightAuthDutyCode = flightAuthDutyCode.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - flightAuthDutyCode")
            return
        }
        guard let flyingOranization = flyingOranization.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - flyingOranization")
            return
        }

        if isEditingMember {
            guard let crewMember = self.crewMemberToEdit else {
                NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - isEditingMember = true, but crewMemberToEdit undefined.")
                return
            }

            Alerts.showInputErrorAlert(on: self) { (_) in

                Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOranization: flyingOranization)

                self.closePopUp()
            }
        } else {

            guard let form = Form781Controller.shared.getCurrentForm() else {
                NSLog("WARNING: AircrewViewController: presentAlertIfInputError() - isEditingMember = false, but no current form.")
                return
            }

            Alerts.showInputErrorAlert(on: self) { (_) in

                CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOranization: flyingOranization)

                self.closePopUp()
            }
        }
    }

    func highlight() {
        lastName.highlightRedIfBlank()
        firstName.highlightRedIfBlank()
        ssn.highlightRedIfBlank()
        flightAuthDutyCode.highlightRedIfBlank()
        flyingOranization.highlightRedIfBlank()
    }

    func unhighlight() {
        lastName.removeAnyColorHighlight()
        firstName.removeAnyColorHighlight()
        ssn.removeAnyColorHighlight()
        flightAuthDutyCode.removeAnyColorHighlight()
        flyingOranization.removeAnyColorHighlight()
    }

    func clearFields() {
        lastName.text = nil
        firstName.text = nil
        ssn.text = nil
        flightAuthDutyCode.text = nil
        flyingOranization.text = nil
    }

    func populateFields(crewMember: CrewMember) {
        lastName.text = crewMember.lastName
        firstName.text = crewMember.firstName
        ssn.text = crewMember.ssnLast4
        flightAuthDutyCode.text = crewMember.flightAuthDutyCode
        flyingOranization.text = crewMember.flyingOranization
    }

    func closePopUp() {
        isEditingMember = false
        clearFields()
        saveButton.setTitle("+ ADD NEW CREW", for: .normal)
        unhighlight()
        delegate?.closeAircrewPopUp()
    }
    
    // MARK: - Actions
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        highlight()
        #warning("Should we split this up? If *.text is nil this is some other error. If the item is empty, we handle it with presentAlertIfInputError().")
        guard let lastName = lastName.text, !lastName.isEmpty,
              let firstName = firstName.text, !firstName.isEmpty,
              let ssn = ssn.text, !ssn.isEmpty,
              let flyingOranization = flyingOranization.text, !flyingOranization.isEmpty,
              let flightAuthDutyCode = flightAuthDutyCode.text, !flightAuthDutyCode.isEmpty
        else {
            return self.presentAlertIfInputError()
        }

        if isEditingMember {
            guard let crewMember = self.crewMemberToEdit else {
                NSLog("ERROR: AircrewViewController: saveButtonTapped() - isEditingMember = true, but crewMemberToEdit undefined.")
                return
            }

            Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOranization: flyingOranization)

            closePopUp()

        } else {

            guard let form = Form781Controller.shared.getCurrentForm() else {
                NSLog("WARNING: AircrewViewController: saveButtonTapped() - isEditingMember = false, but no current form.")
                return
            }

            CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOranization: flyingOranization)

            closePopUp()
        }
    }

    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        ssn.resignFirstResponder()
        flyingOranization.resignFirstResponder()
        flightAuthDutyCode.resignFirstResponder()
    }
    
} //End

// MARK: - UITextField Delegate

extension AircrewPopUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End

// MARK: - Delegates

extension AircrewPopUpViewController: MainViewControllerAircrewPopUpDelegate {
    
    func editAircrewButtonTapped(crewMember: CrewMember) {
        populateFields(crewMember: crewMember)
        isEditingMember = true
        crewMemberToEdit = crewMember
        saveButton.setTitle("SAVE", for: .normal)
    }
    
} //End
