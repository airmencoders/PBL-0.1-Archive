//
//  MissionDataViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol MissionDataViewControllerDelegate: class {
    func updateDimView(toHidden: Bool)
}

class MissionDataViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mdsLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var unitChargedLabel: UILabel!
    @IBOutlet weak var harmLocationLabel: UILabel!
    @IBOutlet weak var flightAuthLabel: UILabel!
    @IBOutlet weak var issuingUnitLabel: UILabel!
    
    @IBOutlet weak var missionDataPopUp: UIView!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mdsTextField: UITextField!
    @IBOutlet weak var serialNumTextField: UITextField!
    @IBOutlet weak var unitChargedTextField: UITextField!
    @IBOutlet weak var harmLocationTextField: UITextField!
    @IBOutlet weak var flightAuthTextField: UITextField!
    @IBOutlet weak var issuingUnitTextField: UITextField!
    
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var flightSeqPopUp: UIView!
    
    @IBOutlet weak var missionNumber: UITextField!
    @IBOutlet weak var missionSymbol: UITextField!
    @IBOutlet weak var fromICAO: UITextField!
    @IBOutlet weak var toICAO: UITextField!
    @IBOutlet weak var specialUse: UITextField!
    @IBOutlet weak var takeOffTime: UITextField!
    @IBOutlet weak var landTime: UITextField!
    @IBOutlet weak var totalTime: UITextField!
    @IBOutlet weak var touchAndGo: UITextField!
    @IBOutlet weak var fullStop: UITextField!
    @IBOutlet weak var totalLandings: UITextField!
    @IBOutlet weak var sorties: UITextField!
    
    @IBOutlet weak var grandTotalTime: UILabel!
    @IBOutlet weak var grandTouchGo: UILabel!
    @IBOutlet weak var grandFullStop: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var grandSorties: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: MissionDataViewControllerDelegate?
    var isEditingFlight = false
    var flightToEdit: Flight?
    var takeOffTimeString: String = ""
    var landTimeString: String = ""
    private var savedDateTextFieldText: String = ""

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        loadFromData()
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
        dateTextField.delegate = self
        mdsTextField.delegate = self
        serialNumTextField.delegate = self
        unitChargedTextField.delegate = self
        harmLocationTextField.delegate = self
        flightAuthTextField.delegate = self
        issuingUnitTextField.delegate = self
        missionNumber.delegate = self
        missionSymbol.delegate = self
        fromICAO.delegate = self
        toICAO.delegate = self
        specialUse.delegate = self
        takeOffTime.delegate = self
        landTime.delegate = self
        totalTime.delegate = self
        touchAndGo.delegate = self
        fullStop.delegate = self
        totalLandings.delegate = self
        sorties.delegate = self
        disableBackground()
        updateLabels()
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return
        }
        updateGrandTotals(form: form)
    }
    
    func loadFromData(){
        do {
            try Form781Controller.shared.loadForms()
        } catch {
            NSLog("\(Form781Error.FileNotFound)")
        }
        
        let form = Form781Controller.shared.getCurrentForm()
        if Helper.checkForFile(filePath: Form781Controller.shared.fileURL(filename: Form781Controller.shared.loggingFileName)){
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
        if let form = Form781Controller.shared.getCurrentForm() {
            dateLabel.text = form.date
            mdsLabel.text = form.mds
            serialNumberLabel.text = form.serialNumber
            unitChargedLabel.text = form.unitCharged
            harmLocationLabel.text = form.harmLocation
            issuingUnitLabel.text = form.issuingUnit
            flightAuthLabel.text = form.flightAuthNum
        } else {
            dateLabel.text = nil
            mdsLabel.text = nil
            serialNumberLabel.text = nil
            unitChargedLabel.text = nil
            harmLocationLabel.text = nil
            issuingUnitLabel.text = nil
            flightAuthLabel.text = nil
        }
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
    
    func presentAlertIfMissionInputError() {
        guard let date = dateTextField.text,
              let mds = mdsTextField.text,
              let serialNumber = serialNumTextField.text,
              let unitCharged = unitChargedTextField.text,
              let harmLocation = harmLocationTextField.text,
              let flightAuthNum = flightAuthTextField.text,
              let issuingUnit = issuingUnitTextField.text
        else {
            return
        }
        
        Alerts.showInputErrorAlert(on: self) { (_) in
            
            if Form781Controller.shared.formCreated == false {
                Form781Controller.shared.create(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
            } else {
                Form781Controller.shared.updateMissionData(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
            }
            
            self.closePopUp()
        }
    }
    
    func presentAlertIfFlightInputError() {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return
        }
                
        guard let missionNumber = missionNumber.text,
              let missionSymbol = missionSymbol.text,
              let fromICAO = fromICAO.text,
              let toICAO = toICAO.text,
              let totalTime = totalTime.text,
              let touchAndGo = touchAndGo.text,
              let fullStop = fullStop.text,
              let totalLandings = totalLandings.text,
              let sorties = sorties.text,
              let specialUse = specialUse.text
        else {
            return
        }
        
        if isEditingFlight {
            
            guard let flight = self.flightToEdit else {
                return
            }
            
            Alerts.showInputErrorAlert(on: self) { (_) in
            
                Form781Controller.shared.updateFlight(flight: flight, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: self.takeOffTimeString, landTime: self.landTimeString, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
                
                self.closePopUp()
            }
        } else {
            
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
                
                self.updateGrandTotals(form: form)
                self.closePopUp()
            }
        }
    }
    
    func highlightMissionData() {
        dateTextField.text == "" ? Helper.highlightRed(textField: dateTextField) : Helper.unhighlight(textField: dateTextField)
        mdsTextField.text == "" ? Helper.highlightRed(textField: mdsTextField) : Helper.unhighlight(textField: mdsTextField)
        serialNumTextField.text == "" ? Helper.highlightRed(textField: serialNumTextField) : Helper.unhighlight(textField: serialNumTextField)
        unitChargedTextField.text == "" ? Helper.highlightRed(textField: unitChargedTextField) : Helper.unhighlight(textField: unitChargedTextField)
        harmLocationTextField.text == "" ? Helper.highlightRed(textField: harmLocationTextField) : Helper.unhighlight(textField: harmLocationTextField)
        flightAuthTextField.text == "" ? Helper.highlightRed(textField: flightAuthTextField) : Helper.unhighlight(textField: flightAuthTextField)
        issuingUnitTextField.text == "" ? Helper.highlightRed(textField: issuingUnitTextField) : Helper.unhighlight(textField: issuingUnitTextField)
    }
    
    func highlightFlightSeq() {
        missionNumber.text == "" ? Helper.highlightRed(textField: missionNumber) : Helper.unhighlight(textField: missionNumber)
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
    }
    
    func unhighlight() {
        Helper.unhighlight(textField: dateTextField)
        Helper.unhighlight(textField: mdsTextField)
        Helper.unhighlight(textField: serialNumTextField)
        Helper.unhighlight(textField: unitChargedTextField)
        Helper.unhighlight(textField: harmLocationTextField)
        Helper.unhighlight(textField: flightAuthTextField)
        Helper.unhighlight(textField: issuingUnitTextField)
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
    
    func clearFlightFields() {
        missionNumber.text = nil
        missionSymbol.text = nil
        fromICAO.text = nil
        toICAO.text = nil
        specialUse.text = nil
        takeOffTime.text = nil
        landTime.text = nil
        totalTime.text = nil
        touchAndGo.text = nil
        fullStop.text = nil
        totalLandings.text = nil
        sorties.text = nil
    }
    
    func populateFlightFields(flight: Flight) {
        missionNumber.text = flight.missionNumber
        missionSymbol.text = flight.missionSymbol
        fromICAO.text = flight.fromICAO
        toICAO.text = flight.toICAO
        specialUse.text = flight.specialUse
        takeOffTime.text = flight.takeOffTime
        landTime.text = flight.landTime
        totalTime.text = flight.totalTime
        touchAndGo.text = flight.touchAndGo
        fullStop.text = flight.fullStop
        totalLandings.text = flight.totalLandings
        sorties.text = flight.sorties
    }
    
    func openFlightPopUp() {
        unhighlight()
        flightSeqPopUp.isHidden = false
        dimView.isHidden = false
        delegate?.updateDimView(toHidden: false)
        disableBackground()
    }
    
    func closePopUp() {
        updateLabels()
        flightSeqTableView.reloadData()
        isEditingFlight = false
        flightSeqPopUp.isHidden = true
        missionDataPopUp.isHidden = true
        dimView.isHidden = true
        delegate?.updateDimView(toHidden: true)
        clearFlightFields()
        enableBackground()
    }
    
    func disableBackground() {
        flightSeqTableView.isUserInteractionEnabled = false
        editButton.isUserInteractionEnabled = false
    }
    
    func enableBackground() {
        flightSeqTableView.isUserInteractionEnabled = true
        editButton.isUserInteractionEnabled = true
    }

    // MARK: - Actions
    
    @IBAction func editMissionButtonTapped(_ sender: UIButton) {
        unhighlight()
        missionDataPopUp.isHidden = false
        dimView.isHidden = false
        delegate?.updateDimView(toHidden: false)
        disableBackground()
    }
    
    @IBAction func saveMissionDataTapped(_ sender: UIButton) {
        highlightMissionData()
        
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
        
        if Form781Controller.shared.formCreated == false {
            Form781Controller.shared.create(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        } else {
            Form781Controller.shared.updateMissionData(date: date, mds: mds, serialNumber: serialNumber, unitCharged: unitCharged, harmLocation: harmLocation, flightAuthNum: flightAuthNum, issuingUnit: issuingUnit)
        }
        
        closePopUp()
    }
    
    @IBAction func newFlightButtonTapped(_ sender: UIButton) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return Alerts.showNoFormAlert(on: self)
        }
        guard form.flights.count < 6 else {
            return Alerts.showFlightsErrorAlert(on: self)
        }
        openFlightPopUp()
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func checkTime(_ sender: UITextField) {
        do {
            let _ = try Helper.validateTime(timeString: sender.text!)
            Helper.unhighlight(textField: sender)
            NSLog("Time is valid")
        } catch Form781Error.InvalidHours {
            Alerts.showHoursError(on: self)
            Helper.highlightRed(textField: sender)
        } catch Form781Error.InvalidMins {
            Alerts.showMinError(on: self)
            Helper.highlightRed(textField: sender)
//        } catch Form781Error.NoTimeFound {
//            Helper.highlightRed(textField: sender)
//            NSLog("No time found")
        } catch {
            NSLog("checkTakeOffTime function unknown Error")
        }
    }
    
    @IBAction func calculateTotalTime(_ sender: Any) {
        if Helper().checkInput(time: takeOffTime.text!) {
            takeOffTimeString = takeOffTime.text!
            Helper.unhighlight(textField: takeOffTime)
            
            if Helper().checkInput(time: landTime.text!) {
                landTimeString = landTime.text!
                Helper.unhighlight(textField: landTime)
                
                let decimalTime = Helper.vmCalculateTotalTime(takeOffTime: takeOffTime.text, landTime: landTime.text)
                totalTime.text = decimalTime
            } else {
                if landTime.text == "" {
                    landTime.text = ""
                    totalTime.text = ""
                    Helper.highlightRed(textField: landTime)
                    Alerts.showTimeErrorAlert(on: self)
                } else {
                    Helper.highlightRed(textField: landTime)
                    Alerts.showTimeErrorAlert(on: self)
                }
            }
        } else {
            if takeOffTime.text == "" {
                takeOffTime.text = ""
                totalTime.text = ""
                Helper.highlightRed(textField: takeOffTime)
                Alerts.showTimeErrorAlert(on: self)
            } else {
                Helper.highlightRed(textField: takeOffTime)
                Alerts.showTimeErrorAlert(on: self)
            }
        }
    }
        
    @IBAction func calculateTotalLandings(_sender: Any) {
        //Here's where we do the math for filling in the total field
        if Helper.validateNumericalInput(input: touchAndGo){
            if Helper.validateNumericalInput(input: fullStop){
                Helper.unhighlight(textField: touchAndGo)
                Helper.unhighlight(textField: fullStop)
                totalLandings.text = Helper.vmCalculateLandings(touchAndGo: touchAndGo.text!, fullStop: fullStop.text!)
            } else {
                Helper.unhighlight(textField: touchAndGo)
                Helper.highlightRed(textField: fullStop)
            }
        } else {
            Helper.highlightRed(textField: touchAndGo)
        }
    }

    @IBAction func saveFlightButtonTapped(_ sender: UIButton) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return
        }
        highlightFlightSeq()
                
        guard let missionNumber = missionNumber.text, !missionNumber.isEmpty,
              let missionSymbol = missionSymbol.text, !missionSymbol.isEmpty,
              let fromICAO = fromICAO.text, !fromICAO.isEmpty,
              let toICAO = toICAO.text, !toICAO.isEmpty,
              let totalTime = totalTime.text,!totalTime.isEmpty,
              let touchAndGo = touchAndGo.text, !touchAndGo.isEmpty,
              let fullStop = fullStop.text, !fullStop.isEmpty,
              let totalLandings = totalLandings.text, !totalLandings.isEmpty,
              let sorties = sorties.text, !sorties.isEmpty,
              let specialUse = specialUse.text
        else {
            return presentAlertIfFlightInputError()
        }
        
        if isEditingFlight {
            
            guard let flight = self.flightToEdit else {
                return
            }
            
            Form781Controller.shared.updateFlight(flight: flight, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: takeOffTimeString, landTime: landTimeString, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
            
            closePopUp()
            
        } else {
            
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
            
            FlightController.create(form: form, flightSeq: flightSeq, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: takeOffTimeString, landTime: landTimeString, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
            
            updateGrandTotals(form: form)
            closePopUp()
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        dateTextField.resignFirstResponder()
        mdsTextField.resignFirstResponder()
        serialNumTextField.resignFirstResponder()
        unitChargedTextField.resignFirstResponder()
        harmLocationTextField.resignFirstResponder()
        flightAuthTextField.resignFirstResponder()
        issuingUnitTextField.resignFirstResponder()
        
        missionNumber.resignFirstResponder()
        missionSymbol.resignFirstResponder()
        fromICAO.resignFirstResponder()
        toICAO.resignFirstResponder()
        specialUse.resignFirstResponder()
        
        takeOffTime.resignFirstResponder()
        landTime.resignFirstResponder()
        totalTime.resignFirstResponder()
        touchAndGo.resignFirstResponder()
        fullStop.resignFirstResponder()
        totalLandings.resignFirstResponder()
        sorties.resignFirstResponder()
    }
    
} //End

// MARK: - TableView Delegate

extension MissionDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        if let flight = Form781Controller.shared.getCurrentForm()?.flights[indexPath.row] {
            cell.flight = flight
            cell.setUpViews(flight: flight)
        }
        
        return cell
    }
    
} //End

// MARK: - FlightTableViewCell Delegate

extension MissionDataViewController: FlightTableViewCellDelegate {
    
    func editButtonTapped(cell: FlightTableViewCell) {
        guard let flight = cell.flight else {
            return
        }
        populateFlightFields(flight: flight)
        isEditingFlight = true
        flightToEdit = flight
        openFlightPopUp()
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm(),
              let indexPath = flightSeqTableView.indexPath(for: cell) else { return }
        let flight = form.flights[indexPath.row]
        Form781Controller.shared.remove(flight: flight, from: form)
        flightSeqTableView.reloadData()
        
        updateGrandTotals(form: form)
    }
    
} //End

// MARK: - UITextField Delegate

extension MissionDataViewController: UITextFieldDelegate {
    
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
            let date = Helper.dateFromString(dateString)

            if let date = date {
                textField.text = Helper.stdFormattedDate(with: date)
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
