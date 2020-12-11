//
//  SplitFlightConditionsViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class SplitFlightConditionsViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var flightConditionsTableView: UITableView!
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var flightSeqButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        #warning("Save here?")
        
        if let viewController = UIStoryboard(name: "Overview", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "Page1") as? OverviewViewController {
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    
} //End

// MARK: - TableView Delegate

extension SplitFlightConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.flightConditionsTableView {
            return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
        }
        if tableView == self.flightSeqTableView {
            return Form781Controller.shared.getCurrentForm()?.flights.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.flightConditionsTableView {
            guard let cell = self.flightConditionsTableView.dequeueReusableCell(withIdentifier: "FlightConditionsCell", for: indexPath) as? FlightConditionsTableViewCell else { return UITableViewCell() }
            
            if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] as? CrewMember {
                cell.setUpViews(crewMember: crewMember)
            }
            
            return cell
        }
        if tableView == self.flightSeqTableView {
            guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            if let flight = Form781Controller.shared.getCurrentForm()?.flights[indexPath.row] as? Flight {
                cell.setUpViews(flight: flight)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
} //End

extension SplitFlightConditionsViewController: FlightTableViewCellDelegate {
    func editButtonTapped(cell: FlightTableViewCell) {
        
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
    }
}
