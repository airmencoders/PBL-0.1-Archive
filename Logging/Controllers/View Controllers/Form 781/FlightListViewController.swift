//
//  FlightListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/27/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightListViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flightTableView: UITableView!
    @IBOutlet weak var popUpView: UIView!
    
    @IBOutlet weak var flightSeq: UITextField!
    @IBOutlet weak var missionNumber: UITextField!
    @IBOutlet weak var missionSymbol: UITextField!
    @IBOutlet weak var fromICAO: UITextField!
    @IBOutlet weak var toICAO: UITextField!
    
    @IBOutlet weak var takeOffTime: UITextField!
    @IBOutlet weak var landTime: UITextField!
    @IBOutlet weak var totalTime: UITextField!
    
    @IBOutlet weak var touchAndGo: UITextField!
    @IBOutlet weak var fullStop: UITextField!
    @IBOutlet weak var totalLandings: UITextField!
    @IBOutlet weak var sorties: UITextField!
    @IBOutlet weak var specialUse: UITextField!
    
    @IBOutlet weak var grandTotalTime: UILabel!
    @IBOutlet weak var grandTouchGo: UILabel!
    @IBOutlet weak var grandFullStop: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var grandSorties: UILabel!
    
    // MARK: - Local Variables
    var takeOffTimeString: String = " "
    var landTimeString: String = " "
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        flightTableView.delegate = self
        flightTableView.dataSource = self
        setUpViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        Form781Controller.shared.loadFlights()
        guard let form = Form781Controller.shared.forms.last else { return }
        updateGrandTotals(form: form)
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newFlightButtonTapped(_ sender: UIButton) {
        popUpView.isHidden = false
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        popUpView.isHidden = true
    }
    
    @IBAction func calculateTotalTime(_ sender: Any) {
        
        if Helper().checkInput(time: takeOffTime.text!) {
            if Helper().checkInput(time: landTime.text!) {
                takeOffTimeString = takeOffTime.text!
                landTimeString = landTime.text!
                let decimalTime = Helper().vmCalculateTotalTime(takeOffTime: takeOffTime, landTime: landTime)
                totalTime.text = decimalTime
            } else {
                throwAlert(alertTitle: "Landing time error")
            }
        } else {
            throwAlert(alertTitle: "Take Off time error")
        }
    }
    
    @IBAction func calculateTotalLandings(_sender: Any) {
        //Here's where we do the math for filling in the total field
        totalLandings.text = Helper().vmCalculateLandings(touchAndGo: touchAndGo, fullStop: fullStop)
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
    
    func presentAlert() {
        guard let form = Form781Controller.shared.forms.last,
              let flightSeq = flightSeq.text,
              let missionNumber = missionNumber.text,
              let missionSymbol = missionSymbol.text,
              let fromICAO = fromICAO.text,
              let toICAO = toICAO.text,
              let totalTime = totalTime.text,
              let touchAndGo = touchAndGo.text,
              let fullStop = fullStop.text,
              let totalLandings = totalLandings.text,
              let sorties = sorties.text,
              let specialUse = specialUse.text
        else { return }
        
        Alerts.showTextFieldsAlert(on: self) { (_) in
            
            FlightController.create(form: form, flightSeq: flightSeq, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: takeOffTime, landTime: landTime, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
            
            self.flightTableView.reloadData()
            self.updateGrandTotals(form: form)
            self.popUpView.isHidden = true
            print("Saved flight")
        }
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newFlightButtonTapped(_ sender: UIButton) {
        popUpView.isHidden = false
    }
    
    @IBAction func exitButtonTapped(_ sender: UIButton) {
        popUpView.isHidden = true
    }
    
    @IBAction func calculateTotalTime(_ sender: Any) {
        let decimalTime = Helper().vmCalculateTotalTime(takeOffTime: takeOffTime, landTime: landTime)
        totalTime.text = decimalTime
    }
    
    @IBAction func calculateTotalLandings(_sender: Any) {
        //Here's where we do the math for filling in the total field
        totalLandings.text = Helper().vmCalculateLandings(touchAndGo: touchAndGo, fullStop: fullStop)
    }

    @IBAction func addFlightButtonTapped(_ sender: UIButton) {
        
        #warning("TO DO: Functionality for limiting number of flights in array")
        guard let form = Form781Controller.shared.forms.last,
              let flightSeq = flightSeq.text, !flightSeq.isEmpty,
              let missionNumber = missionNumber.text, !missionNumber.isEmpty,
              let missionSymbol = missionSymbol.text, !missionSymbol.isEmpty,
              let fromICAO = fromICAO.text, !fromICAO.isEmpty,
              let toICAO = toICAO.text, !toICAO.isEmpty,
              let takeOffTime = takeOffTime.text, !takeOffTime.isEmpty,
              let landTime = landTime.text, !landTime.isEmpty,
              let totalTime = totalTime.text,!totalTime.isEmpty,
              let touchAndGo = touchAndGo.text, !touchAndGo.isEmpty,
              let fullStop = fullStop.text, !fullStop.isEmpty,
              let totalLandings = totalLandings.text, !totalLandings.isEmpty,
              let sorties = sorties.text, !sorties.isEmpty,
              let specialUse = specialUse.text, !specialUse.isEmpty
        else { return presentAlert() }
        
        FlightController.create(form: form, flightSeq: flightSeq, missionNumber: missionNumber, missionSymbol: missionSymbol, fromICAO: fromICAO, toICAO: toICAO, takeOffTime: takeOffTime, landTime: landTime, totalTime: totalTime, touchAndGo: touchAndGo, fullStop: fullStop, totalLandings: totalLandings, sorties: sorties, specialUse: specialUse)
        
        flightTableView.reloadData()
        updateGrandTotals(form: form)
        popUpView.isHidden = true
        print("Saved flight")
    }
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        if let viewController = UIStoryboard(name: "Aircrew", bundle: nil).instantiateViewController(withIdentifier: "Page1") as? AircrewViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        flightSeq.resignFirstResponder()
        missionNumber.resignFirstResponder()
        missionSymbol.resignFirstResponder()
        fromICAO.resignFirstResponder()
        toICAO.resignFirstResponder()
        takeOffTime.resignFirstResponder()
        landTime.resignFirstResponder()
        totalTime.resignFirstResponder()
        touchAndGo.resignFirstResponder()
        fullStop.resignFirstResponder()
        totalLandings.resignFirstResponder()
        sorties.resignFirstResponder()
        specialUse.resignFirstResponder()
    }
    
} //End

// MARK: - TableView Delegate

extension FlightListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Form781Controller.shared.forms.last?.flights.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.flightTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        if let flight = Form781Controller.shared.forms.last?.flights[indexPath.row] {
            cell.setUpViews(flight: flight)
        }
        
        return cell
    }
    
} //End

extension FlightListViewController: FlightTableViewCellDelegate {
    
    func editButtonTapped(cell: FlightTableViewCell) {
        
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
        guard let form = Form781Controller.shared.forms.last,
              let indexPath = flightTableView.indexPath(for: cell) else { return }
        let flight = form.flights[indexPath.row]
        Form781Controller.shared.remove(flight: flight, from: form)
        flightTableView.reloadData()
        print("Deleted flight")
        
        updateGrandTotals(form: form)
    }
    
} //End

// MARK: -Alerts
    
extension FlightListViewController {
    func throwAlert(alertTitle: String) {
        
        let alert = UIAlertController(title: "Invalid Time", message: "Please enter your time in the 4 digit manner ie 0400", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}
