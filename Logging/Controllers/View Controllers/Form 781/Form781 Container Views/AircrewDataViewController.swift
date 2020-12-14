//
//  AircrewDataViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewDataViewControllerDelegate: class {
    func updateDimView(toHidden: Bool)
    func updateAircrewDataDimViewHidden(toHidden: Bool)
}

class AircrewDataViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var flightTimeTableView: UITableView!
    
    @IBOutlet weak var showFlightSeqButton: UIButton!
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
    
    weak var delegate: AircrewDataViewControllerDelegate?
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
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
        flightTimeTableView.delegate = self
        flightTimeTableView.dataSource = self
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
    
    func presentAlertIfFlightInputError() {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            NSLog("AircrewDataViewController: presentAlertIfFlightInputError(cell: - there is no current form, returning.")
            return
        }
        #warning("Should we split this up? If *.text is nil this is some other error. If the item is empty, we handle it with presentAlertIfInputError().")
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
                NSLog("ERROR: AircrewDataViewController: presentAlertIfFlightInputError() isEditingFlight = true, but no flightToEdit.")
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
        delegate?.updateAircrewDataDimViewHidden(toHidden: false)
        disableBackground()
    }
    
    func closePopUp() {
        flightSeqTableView.reloadData()
        isEditingFlight = false
        flightSeqPopUp.isHidden = true
        dimView.isHidden = true
        delegate?.updateDimView(toHidden: true)
        delegate?.updateAircrewDataDimViewHidden(toHidden: true)
        clearFlightFields()
        enableBackground()
    }
    
    func disableBackground() {
        flightSeqTableView.isUserInteractionEnabled = false
    }
    
    func enableBackground() {
        flightSeqTableView.isUserInteractionEnabled = true
    }

    // MARK: - Actions
    
    @IBAction func flightSeqButtonTapped(_ sender: UIButton) {
        showFlightSeqButton.isSelected.toggle()
        if showFlightSeqButton.isSelected {
            showFlightSeqButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            flightSeqTableView.isHidden = false
        } else {
            showFlightSeqButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            flightSeqTableView.isHidden = true
        }
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
            NSLog("AircrewDataViewController: saveFlightButtonTapped( - there is no current form, returning.")
            return
        }
        highlightFlightSeq()
                
        #warning("Should we split this up? If *.text is nil this is some other error. If the item is empty, we handle it with presentAlertIfInputError().")
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
                NSLog("ERROR: MissionDataViewController: presentAlertIfFlightInputError() isEditingFlight = true, but no flightToEdit.")
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

} //End

// MARK: - TableView Delegate

extension AircrewDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.flightSeqTableView {
            return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
        }
        if tableView == self.flightTimeTableView {
            return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.flightSeqTableView {
            guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else {
                NSLog("ERROR: AircrewDataViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightCell\", if it's there it's not a FlightTableViewCell.")
                return UITableViewCell()
            }
            
            cell.delegate = self
            if let flight = Form781Controller.shared.getCurrentForm()?.flights[indexPath.row] {
                cell.flight = flight
                cell.setUpViews(flight: flight)
            }
            
            return cell
        }
        if tableView == self.flightTimeTableView {
            guard let cell = self.flightTimeTableView.dequeueReusableCell(withIdentifier: "FlightTimeCell", for: indexPath) as? FlightTimeTableViewCell else {
                NSLog("ERROR: AircrewDataViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightTimeCell\", if it's there it's not a FlightTimeTableViewCell.")
                return UITableViewCell()
            }
            
            if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
                cell.setUpViews(crewMember: crewMember)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
} //End

// MARK: - FlightTableViewCell Delegate

extension AircrewDataViewController: FlightTableViewCellDelegate {
    
    func editButtonTapped(cell: FlightTableViewCell) {
        guard let flight = cell.flight else {
            NSLog("ERROR: AircrewDataViewController: editButtonTapped(cell: - cell \(cell) has no flight property defined.")
            return
        }
        populateFlightFields(flight: flight)
        isEditingFlight = true
        flightToEdit = flight
        openFlightPopUp()
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            NSLog("AircrewDataViewController: deleteButtonTapped(cell: - there is no current form, nothing to delete..")
            return
        }
        guard let indexPath = flightSeqTableView.indexPath(for: cell) else {
            NSLog("ERROR: MissionDataViewController: deleteButtonTapped() Cell \(cell) not found in flightSeqTableView, nothing deleted.")
            return
        }
        let flight = form.flights[indexPath.row]
        Form781Controller.shared.remove(flight: flight, from: form)
        flightSeqTableView.reloadData()
    }
    
} //End

// MARK: - UITextField Delegate

extension AircrewDataViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End
