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
    }
    
    func presentAlertIfInputError() {
        guard let lastName = lastName.text,
              let firstName = firstName.text,
              let ssn = ssn.text,
              let flightAuthDutyCode = flightAuthDutyCode.text,
              let flyingOrigin = flyingOrigin.text
        else {
            return
        }
        
        if isEditingMember {
            guard let crewMember = self.crewMemberToEdit else {
                return
            }
            
            Alerts.showInputErrorAlert(on: self) { (_) in
                
                Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
                
                self.closePopUp()
            }
        } else {
            
            guard let form = Form781Controller.shared.getCurrentForm()
            else {
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
        lastName.text = ""
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
    
    func closePopUp() {
        aircrewTableView.reloadData()
        isEditingMember = false
        popUpView.isHidden = true
        dimView.isHidden = true
        delegate?.updateDimView(toHidden: true)
        clearFields()
        saveButton.setTitle("+ ADD NEW CREW", for: .normal)
        enableButtons()
    }
    
    func disableButtons() {
        aircrewTableView.isUserInteractionEnabled = false
        //delegate method for main view? Maybe dim view takes care of this
    }
    
    func enableButtons() {
        aircrewTableView.isUserInteractionEnabled = true
        //delegate method for main view? Maybe dim view takes care of this
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        unhighlight()
        popUpView.isHidden = false
        dimView.isHidden = false
        delegate?.updateDimView(toHidden: false)
        disableButtons()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        highlight()
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
                return
            }
            
            Form781Controller.shared.updateCrewMemberInfo(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin)
            
            closePopUp()
            
        } else {
            
            guard let form = Form781Controller.shared.getCurrentForm() else {
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
            return
        }
        unhighlight()
        populateFields(crewMember: crewMember)
        isEditingMember = true
        crewMemberToEdit = cell.crewMember
        saveButton.setTitle("SAVE", for: .normal)
        popUpView.isHidden = false
        dimView.isHidden = false
        delegate?.updateDimView(toHidden: false)
    }

    func deleteButtonTapped(cell: AircrewTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm(),
              let indexPath = aircrewTableView.indexPath(for: cell)
        else {
            return
        }
        let crewMember = form.crewMembers[indexPath.row]
        Form781Controller.shared.remove(crewMember: crewMember, from: form)
        aircrewTableView.reloadData()
    }
    
} //End
