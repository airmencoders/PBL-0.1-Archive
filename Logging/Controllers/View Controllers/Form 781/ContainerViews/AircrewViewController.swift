//
//  AircrewViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/1/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class AircrewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var aircrewTableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var ssn: UITextField!
    @IBOutlet weak var flightAuthDutyCode: UITextField!
    @IBOutlet weak var flyingOrigin: UITextField!
    
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
    
    func presentInputErrorAlert() {
//        guard let form = Form781Controller.shared.forms.last,
//              let lastName = lastName.text,
//              let firstName = firstName.text,
//              let ssn = ssn.text,
//              let flightAuthDutyCode = flightAuthDutyCode.text,
//              let flyingOrigin = flyingOrigin.text,
//        else {
//            return
//        }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            //CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: ins, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
            
            self.aircrewTableView.reloadData()
            self.popUpView.isHidden = true
            self.enableButtons()
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
    
    func disableButtons() {
        aircrewTableView.isUserInteractionEnabled = false
    }
    
    func enableButtons() {
        aircrewTableView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        unhighlight()
        popUpView.isHidden = false
        disableButtons()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        popUpView.isHidden = true
        enableButtons()
    }
    
    @IBAction func addNewAircrewButtonTapped(_ sender: UIButton) {
        highlight()
//        guard let form = Form781Controller.shared.forms.last else { return }
//        guard let lastName = lastName.text, !lastName.isEmpty,
//              let firstName = firstName.text, !firstName.isEmpty,
//              let ssn = ssn.text, !ssn.isEmpty,
//              let flightAuthDutyCode = flightAuthDutyCode.text, !flightAuthDutyCode.isEmpty,
//              let flyingOrigin = flyingOrigin.text, !flyingOrigin.isEmpty,
//        else { return presentInputErrorAlert() }
        
        //CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
        
        aircrewTableView.reloadData()
        popUpView.isHidden = true
        enableButtons()
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
        Form781Controller.shared.forms.last?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.aircrewTableView.dequeueReusableCell(withIdentifier: "AircrewCell", for: indexPath) as? AircrewTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        if let crewMember = Form781Controller.shared.forms.last?.crewMembers[indexPath.row] {
            cell.setUpViews(crewMember: crewMember)
        }
        
        return cell
    }
    
} //End

// MARK: - TableViewCell Delegate

extension AircrewViewController: AircrewTableViewCellDelegate {
    
    func editButtonTapped(cell: AircrewTableViewCell) {
        self.performSegue(withIdentifier: "ToAircrewDetailVC", sender: self)
    }

    func deleteButtonTapped(cell: AircrewTableViewCell) {
        guard let form = Form781Controller.shared.forms.last,
              let indexPath = aircrewTableView.indexPath(for: cell) else { return }
        let crewMember = form.crewMembers[indexPath.row]
        Form781Controller.shared.remove(crewMember: crewMember, from: form)
        aircrewTableView.reloadData()
    }
    
} //End

// MARK: - Detail View Delegate

extension AircrewViewController: AircrewDetailViewControllerDelegate {

    func exitButtonTapped() {
        navigationController?.dismiss(animated: true, completion: {
            self.aircrewTableView.reloadData()
        })
    }
    
    func saveButtonTapped() {
        navigationController?.dismiss(animated: true, completion: {
            self.aircrewTableView.reloadData()
        })
    }
    
} //End
