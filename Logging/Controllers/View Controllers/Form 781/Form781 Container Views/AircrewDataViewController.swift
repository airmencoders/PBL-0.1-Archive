//
//  AircrewDataViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewDataViewControllerDelegate: class {
    func addFlightButtonTapped()
    func editFlightButtonTapped(flight: Flight)
}

class AircrewDataViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var showFlightSeqButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var grandTotalTime: UILabel!
    @IBOutlet weak var grandTouchGo: UILabel!
    @IBOutlet weak var grandFullStop: UILabel!
    @IBOutlet weak var grandTotal: UILabel!
    @IBOutlet weak var grandSorties: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: AircrewDataViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentFormChanged),
                                               name: Form781Controller.FLIGHT_DATA_CHANGED,
                                               object: nil)
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
        currentFormChanged()
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
        flightSeqTableView.reloadData()
        reloadGrandTotalsView()
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
        delegate?.addFlightButtonTapped()
    }
    
} //End

// MARK: - TableView Delegate

extension AircrewDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
} //End

// MARK: - FlightTableViewCell Delegate

extension AircrewDataViewController: FlightTableViewCellDelegate {
    
    func editButtonTapped(cell: FlightTableViewCell) {
        guard let flight = cell.flight else {
            NSLog("ERROR: AircrewDataViewController: editButtonTapped(cell: - cell \(cell) has no flight property defined.")
            return
        }
        delegate?.editFlightButtonTapped(flight: flight)
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
    }
    
} //End

// MARK: - Delegates

extension AircrewDataViewController: Form781ViewControllerFlightSeqDelegate {
    
    func reloadFlightSeqTableView() {
        flightSeqTableView.reloadData()
        reloadGrandTotalsView()
    }
    
} //End

extension AircrewDataViewController: FlightTimePageViewControllerDelegate {
    
    func pageViewController(pageViewController: FlightTimePageViewController, didUpdatePageCount count: Int) {
    }
    
    func pageViewController(pageViewController: FlightTimePageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
} //End

extension AircrewDataViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFlightTimePageVC" {
            guard let destinationVC = segue.destination as? FlightTimePageViewController else {
                return
            }
            destinationVC.tutorialDelegate = self
        }
    }
    
} //End


