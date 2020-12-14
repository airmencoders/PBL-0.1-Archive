//
//  AircrewViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/1/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewViewControllerDelegate: class {
    func updateDimView(toHidden: Bool)
    func updateAircrewListDimViewHidden(toHidden: Bool)
}

class AircrewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var aircrewTableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var ssn: UITextField!
    @IBOutlet weak var flightAuthDutyCode: UITextField!
    @IBOutlet weak var flyingOrigin: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var dimView: UIView!
    
    // MARK: - Properties
    
    var isEditingMember = false
    var crewMemberToEdit: CrewMember?
    weak var delegate: AircrewViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        aircrewTableView.delegate = self
        aircrewTableView.dataSource = self
        lastName.delegate = self
        firstName.delegate = self
        ssn.delegate = self
        flightAuthDutyCode.delegate = self
        flyingOrigin.delegate = self
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
        guard let flyingOrigin = flyingOrigin.text else {
            NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - optional text is nil - flyingOrigin")
            return
        }
        
        if isEditingMember {
            guard let crewMember = self.crewMemberToEdit else {
                NSLog("ERROR: AircrewViewController: presentAlertIfInputError() - isEditingMember = true, but crewMemberToEdit undefined.")
                return
            }
            
            Alerts.showInputErrorAlert(on: self) { (_) in
                
                Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
                
                self.closePopUp()
            }
        } else {
            
            guard let form = Form781Controller.shared.getCurrentForm() else {
                NSLog("WARNING: AircrewViewController: presentAlertIfInputError() - isEditingMember = false, but no current form.")
                return
            }
            
            Alerts.showInputErrorAlert(on: self) { (_) in
                
                CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
                
                self.closePopUp()
            }
        }
    }
    
    func highlight() {
        lastName.text == "" ? Helper.highlightRed(textField: lastName) : Helper.unhighlight(textField: lastName)
        firstName.text == "" ? Helper.highlightRed(textField: firstName) : Helper.unhighlight(textField: firstName)
        ssn.text == "" ? Helper.highlightRed(textField: ssn) : Helper.unhighlight(textField: ssn)
        flightAuthDutyCode.text == "" ? Helper.highlightRed(textField: flightAuthDutyCode) : Helper.unhighlight(textField: flightAuthDutyCode)
        flyingOrigin.text == "" ? Helper.highlightRed(textField: flyingOrigin) : Helper.unhighlight(textField: flyingOrigin)
    }
    
    func unhighlight() {
        Helper.unhighlight(textField: lastName)
        Helper.unhighlight(textField: firstName)
        Helper.unhighlight(textField: ssn)
        Helper.unhighlight(textField: flightAuthDutyCode)
        Helper.unhighlight(textField: flyingOrigin)
    }
    
    func clearFields() {
        lastName.text = nil
        firstName.text = nil
        ssn.text = nil
        flightAuthDutyCode.text = nil
        flyingOrigin.text = nil
    }
    
    func populateFields(crewMember: CrewMember) {
        lastName.text = crewMember.lastName
        firstName.text = crewMember.firstName
        ssn.text = crewMember.ssnLast4
        flightAuthDutyCode.text = crewMember.flightAuthDutyCode
        flyingOrigin.text = crewMember.flyingOrigin
    }
    
    func openPopUp() {
        unhighlight()
        popUpView.isHidden = false
        dimView.isHidden = false
        delegate?.updateDimView(toHidden: false)
        delegate?.updateAircrewListDimViewHidden(toHidden: false)
        disableBackground()
    }
    
    func closePopUp() {
        aircrewTableView.reloadData()
        isEditingMember = false
        popUpView.isHidden = true
        dimView.isHidden = true
        delegate?.updateDimView(toHidden: true)
        delegate?.updateAircrewListDimViewHidden(toHidden: true)
        clearFields()
        saveButton.setTitle("+ ADD NEW CREW", for: .normal)
        enableBackground()
    }
    
    func disableBackground() {
        aircrewTableView.isUserInteractionEnabled = false
    }
    
    func enableBackground() {
        aircrewTableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        openPopUp()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        highlight()
        #warning("Should we split this up? If *.text is nil this is some other error. If the item is empty, we handle it with presentAlertIfInputError().")
        guard let lastName = lastName.text, !lastName.isEmpty,
              let firstName = firstName.text, !firstName.isEmpty,
              let ssn = ssn.text, !ssn.isEmpty,
              let flyingOrigin = flyingOrigin.text, !flyingOrigin.isEmpty,
              let flightAuthDutyCode = flightAuthDutyCode.text, !flightAuthDutyCode.isEmpty
        else {
            return self.presentAlertIfInputError()
        }
        
        if isEditingMember {
            guard let crewMember = self.crewMemberToEdit else {
                NSLog("ERROR: AircrewViewController: saveButtonTapped() - isEditingMember = true, but crewMemberToEdit undefined.")
                return
            }
            
            Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
            
            closePopUp()
            
        } else {
            
            guard let form = Form781Controller.shared.getCurrentForm() else {
                NSLog("WARNING: AircrewViewController: saveButtonTapped() - isEditingMember = false, but no current form.")
                return
            }
            
            CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
            
            closePopUp()
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        ssn.resignFirstResponder()
        flyingOrigin.resignFirstResponder()
        flightAuthDutyCode.resignFirstResponder()
    }
    
} //End

// MARK: - TableView Delegate

extension AircrewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.aircrewTableView.dequeueReusableCell(withIdentifier: "AircrewCell", for: indexPath) as? AircrewTableViewCell else {
            NSLog("ERROR: AircrewViewController: tableView(cellForRowAt:) - dequeue failed for \"AircrewCell\", if it's there it's not a AircrewTableViewCell.")
            return UITableViewCell()
        }
        
        cell.delegate = self
        if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
            cell.crewMember = crewMember
            cell.setUpViews(crewMember: crewMember)
        }
        
        return cell
    }
    
} //End

// MARK: - TableViewCell Delegate

extension AircrewViewController: AircrewTableViewCellDelegate {
    
    func editButtonTapped(cell: AircrewTableViewCell) {
        guard let crewMember = cell.crewMember else {
            NSLog("AircrewViewController: editButtonTapped() the cell \(cell) does not have a crewMember.")
            return
        }
        populateFields(crewMember: crewMember)
        isEditingMember = true
        crewMemberToEdit = crewMember
        saveButton.setTitle("SAVE", for: .normal)
        openPopUp()
    }

    func deleteButtonTapped(cell: AircrewTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            NSLog("AircrewViewController: deleteButtonTapped(cell: - there is no current form, returning.")
            return
        }
        guard let indexPath = aircrewTableView.indexPath(for: cell) else {
            NSLog("ERROR: AircrewViewController: deleteButtonTapped(cell: - The cell \(cell) is not in the table view..")
            return
        }
        let crewMember = form.crewMembers[indexPath.row]
        Form781Controller.shared.remove(crewMember: crewMember, from: form)
        aircrewTableView.reloadData()
    }
    
} //End

// MARK: - UITextField Delegate

extension AircrewViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
