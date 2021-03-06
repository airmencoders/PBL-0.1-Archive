//
//  AircrewDetailViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/29/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewDetailViewControllerDelegate: class {
    func exitButtonTapped()
    func saveButtonTapped()
}

class AircrewDetailViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var ssn: UITextField!
    @IBOutlet weak var flyingOrigin: UITextField!
    @IBOutlet weak var flightAuthDutyCode: UITextField!
    
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
    @IBOutlet weak var resv: UITextField!
    
    var crewMember: CrewMember?
    weak var delegate: AircrewDetailViewControllerDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        guard let crewMember = crewMember else { return }
        
        name.text = "\(crewMember.lastName), \(crewMember.firstName)"
        
        lastName.text = crewMember.lastName
        firstName.text = crewMember.firstName
        ssn.text = crewMember.ssnLast4
        flyingOrigin.text = crewMember.flyingOrigin
        flightAuthDutyCode.text = crewMember.flightAuthDutyCode
        primary.text = crewMember.primary
        secondary.text = crewMember.secondary
        instructor.text = crewMember.instructor
        evaluator.text = crewMember.evaluator
        other.text = crewMember.other
        time.text = crewMember.time
        srty.text = crewMember.srty
        nightPSIE.text = crewMember.nightPSIE
        insPIE.text = crewMember.insPIE
        simIns.text = crewMember.simIns
        nvg.text = crewMember.nvg
        combatTime.text = crewMember.combatTime
        combatSrty.text = crewMember.combatSrty
        combatSptTime.text = crewMember.combatSptTime
        combatSptSrty.text = crewMember.combatSptSrty
        resv.text = crewMember.resvStatus
    }
    
    func presentAlert() {
        guard let crewMember = self.crewMember,
              let lastName = lastName.text,
              let firstName = firstName.text,
              let ssn = ssn.text,
              let flyingOrigin = flyingOrigin.text,
              let flightAuthDutyCode = flightAuthDutyCode.text,
              let primary = primary.text,
              let secondary = secondary.text,
              let instructor = instructor.text,
              let evaluator = evaluator.text,
              let other = other.text,
              let time = time.text,
              let srty = srty.text,
              let nightPSIE = nightPSIE.text,
              let insPIE = insPIE.text,
              let simIns = simIns.text,
              let nvg = nvg.text,
              let combatTime = combatTime.text,
              let combatSrty = combatSrty.text,
              let combatSptTime = combatSptTime.text,
              let combatSptSrty = combatSptSrty.text,
              let resv = resv.text
        else { return }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            Form781Controller.shared.updateCrewMember(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resv)
            
            self.delegate?.saveButtonTapped()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        delegate?.exitButtonTapped()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        guard let crewMember = self.crewMember else { return }
        
        guard let lastName = lastName.text, !lastName.isEmpty,
              let firstName = firstName.text, !firstName.isEmpty,
              let ssn = ssn.text, !ssn.isEmpty,
              let flyingOrigin = flyingOrigin.text, !flyingOrigin.isEmpty,
              let flightAuthDutyCode = flightAuthDutyCode.text, !flightAuthDutyCode.isEmpty,
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
              let resv = resv.text, !resv.isEmpty
        else { return presentAlert() }
        
        Form781Controller.shared.updateCrewMember(crewMember: crewMember, lastName: lastName, firstName: firstName, ssnLast4: ssn, flightAuthDutyCode: flightAuthDutyCode, flyingOrigin: flyingOrigin, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resv)
        
        delegate?.saveButtonTapped()
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        lastName.resignFirstResponder()
        firstName.resignFirstResponder()
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
        resv.resignFirstResponder()
    }
        
} //End
