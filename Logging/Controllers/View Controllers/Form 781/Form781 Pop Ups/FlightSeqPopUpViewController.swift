//
//  FlightSeqPopUpViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/16/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol FlightSeqPopUpViewControllerDelegate: class {
    func closeFlightSeqPopUp()
}

class FlightSeqPopUpViewController: UIViewController {
    
    // MARK: - Outlets

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
    
    // MARK: - Properties
    
    weak var delegate: FlightSeqPopUpViewControllerDelegate?
    var isEditingFlight = false
    var flightToEdit: Flight?
    var takeOffTimeString: String = ""
    var landTimeString: String = ""
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
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
                
                self.updateGrandTotals(form: form)
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
    
    func updateGrandTotals(form: Form781) {
        let grandTotalTime = FlightController.calculateTotalTime()
        let grandTouchGo = FlightController.calculateTotalTouchGo()
        let grandFullStop = FlightController.calculateTotalFullStop()
        let grandTotalLandings = FlightController.calculateTotalLandings()
        let grandTotalSorties = FlightController.calculateTotalSorties()
        
        Form781Controller.shared.updateFormWith(grandTotalTime: grandTotalTime, grandTouchGo: grandTouchGo, grandFullStop: grandFullStop, grandTotalLandings: grandTotalLandings, grandTotalSorties: grandTotalSorties, form: form)
    }
    
    func highlightFlightSeq() {
        
        missionNumber.highlightRedIfBlank()
        missionSymbol.highlightRedIfBlank()
        fromICAO.highlightRedIfBlank()
        toICAO.highlightRedIfBlank()
        specialUse.highlightRedIfBlank()
        takeOffTime.highlightRedIfBlank()
        landTime.highlightRedIfBlank()
        totalTime.highlightRedIfBlank()
        touchAndGo.highlightRedIfBlank()
        fullStop.highlightRedIfBlank()
        totalLandings.highlightRedIfBlank()
        sorties.highlightRedIfBlank()
        
    }
    
    func unhighlight() {
        
        missionNumber.removeAnyColorHighlight()
        missionSymbol.removeAnyColorHighlight()
        fromICAO.removeAnyColorHighlight()
        toICAO.removeAnyColorHighlight()
        specialUse.removeAnyColorHighlight()
        takeOffTime.removeAnyColorHighlight()
        landTime.removeAnyColorHighlight()
        totalTime.removeAnyColorHighlight()
        touchAndGo.removeAnyColorHighlight()
        fullStop.removeAnyColorHighlight()
        totalLandings.removeAnyColorHighlight()
        sorties.removeAnyColorHighlight()

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
    
    func populateFields(flight: Flight) {
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
    
    func closePopUp() {
        isEditingFlight = false
        clearFlightFields()
        unhighlight()
        delegate?.closeFlightSeqPopUp()
    }

    // MARK: - Actions
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        closePopUp()
    }
    
    @IBAction func checkTime(_ sender: UITextField) {
        do {
            let _ = try Utilities.validateTime(sender.text!)
            sender.removeAnyColorHighlight()
            NSLog("Time is valid")
        } catch Form781Error.InvalidHours {
            Alerts.showHoursError(on: self)
            sender.highlightRed()
        } catch Form781Error.InvalidMins {
            Alerts.showMinError(on: self)
            sender.highlightRed()
        } catch Form781Error.InvalidTimeFormat {
            Alerts.showTimeErrorAlert(on: self)
            sender.highlightRed()
        } catch {
            NSLog("checkTakeOffTime function unknown Error")
        }
    }
    
    @IBAction func calculateTotalTime(_ sender: Any) {
        if takeOffTime.text!.isExactlyFourCharacters() {
            takeOffTimeString = takeOffTime.text!
            takeOffTime.removeAnyColorHighlight()
            
            if landTime.text!.isExactlyFourCharacters() {
                landTimeString = landTime.text!
                
                landTime.removeAnyColorHighlight()
                let decimalTime = Utilities.timeBetween(takeOffTime.text, landTime.text)
                totalTime.text = decimalTime
            } else {
                if landTime.text == "" {
                    landTime.text = ""
                    totalTime.text = ""
                    landTime.highlightRed()
                    Alerts.showTimeErrorAlert(on: self)
                } else {
                    landTime.highlightRed()
                    Alerts.showTimeErrorAlert(on: self)
                }
            }
        } else {
            if takeOffTime.text == "" {
                takeOffTime.text = ""
                totalTime.text = ""
                takeOffTime.highlightRed()
                Alerts.showTimeErrorAlert(on: self)
            } else {
                takeOffTime.highlightRed()
                Alerts.showTimeErrorAlert(on: self)
            }
        }
    }
        
    @IBAction func calculateTotalLandings(_sender: Any) {
        //Here's where we do the math for filling in the total field
        if touchAndGo.text!.isDigits{
            if fullStop.text!.isDigits{
                touchAndGo.removeAnyColorHighlight()
                fullStop.removeAnyColorHighlight()
                totalLandings.text = touchAndGo.text! +^+ fullStop.text!
            } else {
                touchAndGo.highlightRed()
                fullStop.highlightRed()
            }
        } else {
            touchAndGo.highlightRed()
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
            
            updateGrandTotals(form: form)
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

// MARK: - UITextField Delegate

extension FlightSeqPopUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
} //End

// MARK: - Delegates

extension FlightSeqPopUpViewController: MainViewControllerFlightSeqPopUpDelegate {
    
    func editFlightButtonTapped(flight: Flight) {
        populateFields(flight: flight)
        isEditingFlight = true
        flightToEdit = flight
    }
    
} //End
