//
//  SplitTimeListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/29/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class SplitFlightTimeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flightTimeTableView: UITableView!
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var flightSeqButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        flightTimeTableView.delegate = self
        flightTimeTableView.dataSource = self
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
    }
    
    // MARK: - Actions
    
    @IBAction func flightSeqButtonTapped(_ sender: UIButton) {
        flightSeqButton.isSelected.toggle()
        if flightSeqButton.isSelected {
            flightSeqButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            flightSeqTableView.isHidden = false
        } else {
            flightSeqButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            flightSeqTableView.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

} //End

// MARK: - TableView Delegate

extension SplitFlightTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.flightTimeTableView {
            return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
        }
        if tableView == self.flightSeqTableView {
            return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.flightTimeTableView {
            guard let cell = self.flightTimeTableView.dequeueReusableCell(withIdentifier: "FlightTimeCell", for: indexPath) as? FlightTimeTableViewCell else {
                return UITableViewCell()
            }

            if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
                cell.setUpViews(crewMember: crewMember)
            }
            
            return cell
        }
        if tableView == self.flightSeqTableView {
            guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            if let flight = Form781Controller.shared.getCurrentForm()?.flights[indexPath.row] {
                cell.setUpViews(flight: flight)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
} //End

extension SplitFlightTimeViewController: FlightTableViewCellDelegate {
    func editButtonTapped(cell: FlightTableViewCell) {
        
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
    }
}
