//
//  MissionDataViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol MissionDataViewControllerDelegate: class {
    func editMissionDataButtonTapped()
    func addFlightButtonTapped()
    func editFlightButtonTapped(flight: Flight)
}

class MissionDataViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mdsLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var unitChargedLabel: UILabel!
    @IBOutlet weak var harmLocationLabel: UILabel!
    @IBOutlet weak var flightAuthLabel: UILabel!
    @IBOutlet weak var issuingUnitLabel: UILabel!
    
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var grandTotalTime: UILabel!
    @IBOutlet weak var grandTouchGo: UILabel!
    @IBOutlet weak var grandFullStop: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var grandSorties: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: MissionDataViewControllerDelegate?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentFormChanged),
                                               name: Form781Controller.flightDataChanged,
                                               object: nil)
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        loadFromData()
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
        updateLabels()
        guard let form = Form781Controller.shared.getCurrentForm() else {
            // Nothing else to do if we don't have a form.
            return
        }
        updateGrandTotals(form: form)
        currentFormChanged()
    }
    
    func loadFromData() {
        Form781Controller.shared.loadForms()
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
        
        Form781Controller.shared.updateFormWith(grandTotalTime: grandTotalTime, grandTouchGo: grandTouchGo, grandFullStop: grandFullStop, grandTotalLandings: grandTotalLandings, grandTotalSorties: grandTotalSorties, form: form)
    }
    
    func reloadGrandTotalsView() {
        if let form = Form781Controller.shared.getCurrentForm() {
            self.grandTotalTime.text = String(form.grandTotalTime ?? 0.0)
            self.grandTouchGo.text = String(form.grandTotalTouchAndGo ?? 0)
            self.grandFullStop.text = String(form.grandTotalFullStop ?? 0)
            self.grandTotal.text = String(form.grandTotalLandings ?? 0)
            self.grandSorties.text = String(form.grandTotalSorties ?? 0)
        }
    }
    
    @objc func currentFormChanged() {
        updateLabels()
        flightSeqTableView.reloadData()
        reloadGrandTotalsView()
    }

    // MARK: - Actions
    
    @IBAction func editMissionButtonTapped(_ sender: UIButton) {
        delegate?.editMissionDataButtonTapped()
    }
    
    @IBAction func newFlightButtonTapped(_ sender: UIButton) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return Alerts.showNoFormAlert(on: self)
        }
        guard form.flights.count < 6 else {
            return Alerts.showFlightsErrorAlert(on: self)
        }
        delegate?.addFlightButtonTapped()
    }
    
} //End

// MARK: - TableView Delegate

extension MissionDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else {
            NSLog("ERROR: MissionDataViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightCell\", if it's there it's not a FlightTableViewCell.")
            return UITableViewCell()
        }
        
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
            NSLog("ERROR: MissionDataViewController: editButtonTapped(cell: the cell does not have a valid flight property.")
            return
        }
        delegate?.editFlightButtonTapped(flight: flight)
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            NSLog("ERROR: MissionDataViewController: deleteButtonTapped() No current form so nothing was deleted.")
            return
        }
        guard let indexPath = flightSeqTableView.indexPath(for: cell) else {
            NSLog("ERROR: MissionDataViewController: deleteButtonTapped() Cell \(cell) not found in flightSeqTableView, nothing deleted.")
            return
        }
        let flight = form.flights[indexPath.row]
        Form781Controller.shared.remove(flight: flight, from: form)
        updateGrandTotals(form: form)
    }
    
} //End

// MARK: - Delegates

extension MissionDataViewController: Form781ViewControllerMissionDataDelegate, Form781ViewControllerFlightSeqDelegate {
    
    func updateMissionDataLabels() {
        updateLabels()
    }
    
    func reloadFlightSeqTableView() {
        flightSeqTableView.reloadData()
        reloadGrandTotalsView()
    }

} //End
