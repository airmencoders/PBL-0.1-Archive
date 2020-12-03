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
        
        let form = Form781Controller.shared.forms.last
        if Helper.checkForFile(filePath: Form781Controller.shared.fileURL()){
            dateTextField.text = form?.date
            mdsTextField.text = form?.mds
            serialNumTextField.text = form?.serialNumber
            unitChargedTextField.text = form?.unitCharged
            harmLocationTextField.text = form?.harmLocation
            flightAuthTextField.text = form?.flightAuthNum
            issuingUnitTextField.text = form?.issuingUnit
        } else {
            dateTextField.text = Helper.getTodaysDate()
        }
    }
    
    func updateLabels() {
        guard let form = Form781Controller.shared.forms.last else { return }

        missionDateLabel.text = "MISSION \(form.date)"
        dateLabel.text = form.date
        mdsLabel.text = form.mds
        serialNumberLabel.text = form.serialNumber
        unitChargedLabel.text = form.unitCharged
        harmLocationLabel.text = form.harmLocation
        issuingUnitLabel.text = form.issuingUnit
        flightAuthLabel.text = form.flightAuthNum
    }
    
    func updateGrandTotals(form: Form781) {
        let grandTotalTime = FlightController.calculateTotalTime()
        let grandTouchGo = FlightController.calculateTotalTouchGo()
        let grandFullStop = FlightController.calculateTotalFullStop()
        let grandTotalLandings = FlightController.calculateTotalLandings()
        let grandTotalSorties = FlightController.calculateTotalSorties()
        
        self.grandTotalTime.text = String(grandTotalTime)
        self.grandTouchGo.text = String(grandTouchGo)
        self.grandFullStop.text = String(grandFullStop)
        self.grandTotal.text = String(grandTotalLandings)
        self.grandSorties.text = String(grandTotalSorties)
        
        Form781Controller.shared.updateFormWith(grandTotalTime: grandTotalTime, grandTouchGo: grandTouchGo, grandFullStop: grandFullStop, grandTotalLandings: grandTotalLandings, grandTotalSorties: grandTotalSorties, form: form)
    }
    
    func presentMissionInputErrorAlert() {
        guard let date = dateTextField.text,
              let mds = mdsTextField.text,
              let serialNumber = serialNumTextField.text,
              let unitCharged = unitChargedTextField.text,
              let harmLocation = harmLocationTextField.text,
              let flightAuthNum = flightAuthTextField.text,
              let issuingUnit = issuingUnitTextField.text
        else { return }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            if Form781Controller.shared.formCreated == false {
                Form781Controller.shared.create(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
            } else {
                Form781Controller.shared.updateMissionData(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
            }
            
            self.updateLabels()
            self.missionDataPopUp.isHidden = true
            self.enableButtons()
        }
    }
    
    func presentFlightInputErrorAlert() {
        guard let form = Form781Controller.shared.forms.last else {
            return
        }
        guard let missionNumber = missionNumber.text else {
            return
        }
        guard let missionSymbol = missionSymbol.text else {
            return
        }
        guard let fromICAO = fromICAO.text else {
            return
        }
        guard let toICAO = toICAO.text else {
            return
        }
        guard let totalTime = totalTime.text else {
            return
        }
        guard let touchAndGo = touchAndGo.text else {
            return
        }
        guard let fullStop = fullStop.text else {
            return
        }
        guard let totalLandings = totalLandings.text else {
            return
        }
        guard let sorties = sorties.text else {
            return
        }
        guard let specialUse = specialUse.text else {
            return
        }
        
                
        var flightSeq = "A"
        switch form.flights.count + 1 {
        case 2:
            flightSeq = "B"
        case 3:
            flightSeq = "C"
        case 4:
            flightSeq = "D"
        case 5:
            flightSeq = "E"
        case 6:
            flightSeq = "F"
        default:
            flightSeq = "A"
        }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            FlightController.create(form: form, flightSeq: flightSeq, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: self.takeOffTimeString, landTime: self.landTimeString, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
            
            self.flightSeqTableView.reloadData()
            self.updateGrandTotals(form: form)
            self.flightSeqPopUp.isHidden = true
            self.enableButtons()
        }
    }
    
    func highlightMissionData() {
        /*
        dateTextField.text == "" ? Helper.highlightRed(textField: dateTextField) : Helper.unhighlight(textField: dateTextField)
        mdsTextField.text == "" ? Helper.highlightRed(textField: mdsTextField) : Helper.unhighlight(textField: mdsTextField)
        serialNumTextField.text == "" ? Helper.highlightRed(textField: serialNumTextField) : Helper.unhighlight(textField: serialNumTextField)
        unitChargedTextField.text == "" ? Helper.highlightRed(textField: unitChargedTextField) : Helper.unhighlight(textField: unitChargedTextField)
        harmLocationTextField.text == "" ? Helper.highlightRed(textField: harmLocationTextField) : Helper.unhighlight(textField: harmLocationTextField)
        flightAuthTextField.text == "" ? Helper.highlightRed(textField: flightAuthTextField) : Helper.unhighlight(textField: flightAuthTextField)
        issuingUnitTextField.text == "" ? Helper.highlightRed(textField: issuingUnitTextField) : Helper.unhighlight(textField: issuingUnitTextField)
        */
        dateTextField.flagBlankText()
        mdsTextField.flagBlankText()
        serialNumTextField.flagBlankText()
        unitChargedTextField.flagBlankText()
        harmLocationTextField.flagBlankText()
        flightAuthTextField.flagBlankText()
        issuingUnitTextField.flagBlankText()
    }
    
    func highlightFlightSeq() {
        /* missionNumber.text == "" ? Helper.highlightRed(textField: missionNumber) : Helper.unhighlight(textField: missionNumber)
        missionSymbol.text == "" ? Helper.highlightRed(textField: missionSymbol) : Helper.unhighlight(textField: missionSymbol)
        fromICAO.text == "" ? Helper.highlightRed(textField: fromICAO) : Helper.unhighlight(textField: fromICAO)
        toICAO.text == "" ? Helper.highlightRed(textField: toICAO) : Helper.unhighlight(textField: toICAO)
        takeOffTime.text == "" ? Helper.highlightRed(textField: takeOffTime) : Helper.unhighlight(textField: takeOffTime)
        landTime.text == "" ? Helper.highlightRed(textField: landTime) : Helper.unhighlight(textField: landTime)
        totalTime.text == "" ? Helper.highlightRed(textField: totalTime) : Helper.unhighlight(textField: totalTime)
        touchAndGo.text == "" ? Helper.highlightRed(textField: touchAndGo) : Helper.unhighlight(textField: touchAndGo)
        fullStop.text == "" ? Helper.highlightRed(textField: fullStop) : Helper.unhighlight(textField: fullStop)
        totalLandings.text == "" ? Helper.highlightRed(textField: totalLandings) : Helper.unhighlight(textField: totalLandings)
        sorties.text == "" ? Helper.highlightRed(textField: sorties) : Helper.unhighlight(textField: sorties)
        */
        missionNumber.flagBlankText()
        missionSymbol.flagBlankText()
        fromICAO.flagBlankText()
        toICAO.flagBlankText()
        takeOffTime.flagBlankText()
        landTime.flagBlankText()
        totalTime.flagBlankText()
        touchAndGo.flagBlankText()
        fullStop.flagBlankText()
        totalLandings.flagBlankText()
        sorties.flagBlankText()
    }
    
    func unhighlightMissionData() {
        Helper.unhighlight(textField: dateTextField)
        Helper.unhighlight(textField: mdsTextField)
        Helper.unhighlight(textField: serialNumTextField)
        Helper.unhighlight(textField: unitChargedTextField)
        Helper.unhighlight(textField: harmLocationTextField)
        Helper.unhighlight(textField: flightAuthTextField)
        Helper.unhighlight(textField: issuingUnitTextField)
    }
    
    func unhighlightFlightSeq() {
        Helper.unhighlight(textField: missionNumber)
        Helper.unhighlight(textField: missionSymbol)
        Helper.unhighlight(textField: fromICAO)
        Helper.unhighlight(textField: toICAO)
        Helper.unhighlight(textField: specialUse)
        Helper.unhighlight(textField: takeOffTime)
        Helper.unhighlight(textField: landTime)
        Helper.unhighlight(textField: totalTime)
        Helper.unhighlight(textField: touchAndGo)
        Helper.unhighlight(textField: fullStop)
        Helper.unhighlight(textField: totalLandings)
        Helper.unhighlight(textField: sorties)

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
