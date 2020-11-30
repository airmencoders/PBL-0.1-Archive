//
//  AircrewListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/22/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class AircrewListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var aircrewTableView: UITableView!
    @IBOutlet weak var popUp1View: UIView!
    @IBOutlet weak var popUp2View: UIView!
    @IBOutlet weak var popUp3View: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var ssn: UITextField!
    @IBOutlet weak var flightAuthDutyCode: UITextField!
    @IBOutlet weak var flyingOrigin: UITextField!
    
    @IBOutlet weak var primary: UITextField!
    @IBOutlet weak var secondary: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var evaluator: UITextField!
    @IBOutlet weak var other: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var srty: UITextField!

    @IBOutlet weak var nightPSIE: UITextField!
    @IBOutlet weak var insPIE: UITextField!
    @IBOutlet weak var simIns: UITextField!
    @IBOutlet weak var nvg: UITextField!
    @IBOutlet weak var combatTime: UITextField!
    @IBOutlet weak var combatSrty: UITextField!
    @IBOutlet weak var combatSptTime: UITextField!
    @IBOutlet weak var combatSptSrty: UITextField!
    @IBOutlet weak var resvStatus: UITextField!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        aircrewTableView.delegate = self
        aircrewTableView.dataSource = self
        
        guard let form = Form781Controller.shared.forms.last else { return }
        headerTitleLabel.text = "Mission \(form.date)"
    }
    
    func presentInputErrorAlert() {
        guard let form = Form781Controller.shared.forms.last,
              let lastName = lastName.text,
              let firstName = firstName.text,
              let ssn = ssn.text,
              let flightAuthDutyCode = flightAuthDutyCode.text,
              let flyingOrigin = flyingOrigin.text,
              let primary = primary.text,
              let secondary = secondary.text,
              let instructor = instructor.text,
              let evaluator = evaluator.text,
              let other = other.text,
              let time = time.text,
              let srty = srty.text,
              let nightPSIE = nightPSIE.text,
              let ins = insPIE.text,
              let simIns = simIns.text,
              let nvg = nvg.text,
              let combatTime = combatTime.text,
              let combatSrty = combatSrty.text,
              let combatSptTime = combatSptTime.text,
              let combatSptSrty = combatSptSrty.text,
              let resvStatus = resvStatus.text
        else { return }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            //CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: ins, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
            
            self.aircrewTableView.reloadData()
            self.popUp3View.isHidden = true
            self.enableButtons()
        }
    }
    
    func highlight() {
        lastName.text == "" ? Helper.highlightRed(textField: lastName) : Helper.unhighlight(textField: lastName)
        firstName.text == "" ? Helper.highlightRed(textField: firstName) : Helper.unhighlight(textField: firstName)
        ssn.text == "" ? Helper.highlightRed(textField: ssn) : Helper.unhighlight(textField: ssn)
        flightAuthDutyCode.text == "" ? Helper.highlightRed(textField: flightAuthDutyCode) : Helper.unhighlight(textField: flightAuthDutyCode)
        flyingOrigin.text == "" ? Helper.highlightRed(textField: flyingOrigin) : Helper.unhighlight(textField: flyingOrigin)
        primary.text == "" ? Helper.highlightRed(textField: primary) : Helper.unhighlight(textField: primary)
        secondary.text == "" ? Helper.highlightRed(textField: secondary) : Helper.unhighlight(textField: secondary)
        instructor.text == "" ? Helper.highlightRed(textField: instructor) : Helper.unhighlight(textField: instructor)
        evaluator.text == "" ? Helper.highlightRed(textField: evaluator) : Helper.unhighlight(textField: evaluator)
        other.text == "" ? Helper.highlightRed(textField: other) : Helper.unhighlight(textField: other)
        time.text == "" ? Helper.highlightRed(textField: time) : Helper.unhighlight(textField: time)
        srty.text == "" ? Helper.highlightRed(textField: srty) : Helper.unhighlight(textField: srty)
        nightPSIE.text == "" ? Helper.highlightRed(textField: nightPSIE) : Helper.unhighlight(textField: nightPSIE)
        insPIE.text == "" ? Helper.highlightRed(textField: insPIE) : Helper.unhighlight(textField: insPIE)
        simIns.text == "" ? Helper.highlightRed(textField: simIns) : Helper.unhighlight(textField: simIns)
        nvg.text == "" ? Helper.highlightRed(textField: nvg) : Helper.unhighlight(textField: nvg)
        combatTime.text == "" ? Helper.highlightRed(textField: combatTime) : Helper.unhighlight(textField: combatTime)
        combatSrty.text == "" ? Helper.highlightRed(textField: combatSrty) : Helper.unhighlight(textField: combatSrty)
        combatSptTime.text == "" ? Helper.highlightRed(textField: combatSptTime) : Helper.unhighlight(textField: combatSptTime)
        combatSptSrty.text == "" ? Helper.highlightRed(textField: combatSptSrty) : Helper.unhighlight(textField: combatSptSrty)
        resvStatus.text == "" ? Helper.highlightRed(textField: resvStatus) : Helper.unhighlight(textField: resvStatus)
    }
    
    func unhighlight() {
        Helper.unhighlight(textField: lastName)
        Helper.unhighlight(textField: firstName)
        Helper.unhighlight(textField: ssn)
        Helper.unhighlight(textField: flightAuthDutyCode)
        Helper.unhighlight(textField: flyingOrigin)
        Helper.unhighlight(textField: primary)
        Helper.unhighlight(textField: secondary)
        Helper.unhighlight(textField: instructor)
        Helper.unhighlight(textField: evaluator)
        Helper.unhighlight(textField: other)
        Helper.unhighlight(textField: time)
        Helper.unhighlight(textField: srty)
        Helper.unhighlight(textField: nightPSIE)
        Helper.unhighlight(textField: insPIE)
        Helper.unhighlight(textField: simIns)
        Helper.unhighlight(textField: nvg)
        Helper.unhighlight(textField: combatTime)
        Helper.unhighlight(textField: combatSrty)
        Helper.unhighlight(textField: combatSptTime)
        Helper.unhighlight(textField: combatSptSrty)
        Helper.unhighlight(textField: resvStatus)
    }
    
    func disableButtons() {
        aircrewTableView.isUserInteractionEnabled = false
        printButton.isUserInteractionEnabled = false
        backButton.isUserInteractionEnabled = false
        continueButton.isUserInteractionEnabled = false
    }
    
    func enableButtons() {
        aircrewTableView.isUserInteractionEnabled = true
        printButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        continueButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        unhighlight()
        popUp1View.isHidden = false
        disableButtons()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        popUp1View.isHidden = true
        popUp2View.isHidden = true
        popUp3View.isHidden = true
        enableButtons()
    }
    
    @IBAction func back2ButtonTapped(_ sender: UIButton) {
        popUp2View.isHidden = true
        popUp1View.isHidden = false
    }
    
    @IBAction func back3ButtonTapped(_ sender: UIButton) {
        popUp3View.isHidden = true
        popUp2View.isHidden = false
    }
    
    @IBAction func next1ButtonTapped(_ sender: UIButton) {
        popUp1View.isHidden = true
        popUp2View.isHidden = false
    }
    
    @IBAction func next2ButtonTapped(_ sender: UIButton) {
        popUp2View.isHidden = true
        popUp3View.isHidden = false
    }
    
    @IBAction func addNewAircrewButtonTapped(_ sender: UIButton) {
        highlight()
        guard let form = Form781Controller.shared.forms.last else { return }
        guard let lastName = lastName.text, !lastName.isEmpty,
              let firstName = firstName.text, !firstName.isEmpty,
              let ssn = ssn.text, !ssn.isEmpty,
              let flightAuthDutyCode = flightAuthDutyCode.text, !flightAuthDutyCode.isEmpty,
              let flyingOrigin = flyingOrigin.text, !flyingOrigin.isEmpty,
              let primary = primary.text, !primary.isEmpty,
              let secondary = secondary.text, !secondary.isEmpty,
              let instructor = instructor.text, !instructor.isEmpty,
              let evaluator = evaluator.text, !evaluator.isEmpty,
              let other = other.text, !other.isEmpty,
              let time = time.text, !time.isEmpty,
              let srty = srty.text, !srty.isEmpty,
              let nightPSIE = nightPSIE.text, !nightPSIE.isEmpty,
              let insPIE = insPIE.text, !insPIE.isEmpty,
              let simIns = simIns.text, !simIns.isEmpty,
              let nvg = nvg.text, !nvg.isEmpty,
              let combatTime = combatTime.text, !combatTime.isEmpty,
              let combatSrty = combatSrty.text, !combatSrty.isEmpty,
              let combatSptTime = combatSptTime.text, !combatSptTime.isEmpty,
              let combatSptSrty = combatSptSrty.text, !combatSptSrty.isEmpty,
              let resvStatus = resvStatus.text, !resvStatus.isEmpty
        else { return presentInputErrorAlert() }
        
        //CrewMemberController.create(form: form, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
        
        aircrewTableView.reloadData()
        popUp3View.isHidden = true
        enableButtons()
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "SplitTime", bundle: nil).instantiateViewController(withIdentifier: "Page1") as? SplitTimeViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        ssn.resignFirstResponder()
        flyingOrigin.resignFirstResponder()
        flightAuthDutyCode.resignFirstResponder()
        primary.resignFirstResponder()
        secondary.resignFirstResponder()
        instructor.resignFirstResponder()
        evaluator.resignFirstResponder()
        other.resignFirstResponder()
        time.resignFirstResponder()
        srty.resignFirstResponder()
        nightPSIE.resignFirstResponder()
        insPIE.resignFirstResponder()
        simIns.resignFirstResponder()
        nvg.resignFirstResponder()
        combatTime.resignFirstResponder()
        combatSrty.resignFirstResponder()
        combatSptTime.resignFirstResponder()
        combatSptSrty.resignFirstResponder()
        resvStatus.resignFirstResponder()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAircrewDetailVC" {
            guard let indexPath = aircrewTableView.indexPathForSelectedRow, let destinationVC = segue.destination as? AircrewDetailViewController else { return }
            let crewMember = Form781Controller.shared.forms.last?.crewMembers[indexPath.row]
            destinationVC.crewMember = crewMember
            destinationVC.delegate = self
        }
    }
    
} //End

// MARK: - TableView Delegate

extension AircrewListViewController: UITableViewDelegate, UITableViewDataSource {
    
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

extension AircrewListViewController: AircrewTableViewCellDelegate {
    
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

extension AircrewListViewController: AircrewDetailViewControllerDelegate {

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
