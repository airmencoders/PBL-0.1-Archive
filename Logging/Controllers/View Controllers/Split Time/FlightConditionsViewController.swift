//
//  FlightConditionsViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/30/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightConditionsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flightConditionsTableView: UITableView!
    
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
        flightConditionsTableView.delegate = self
        flightConditionsTableView.dataSource = self
        currentFormChanged()
    }
    
    @objc func currentFormChanged() {
        flightConditionsTableView.reloadData()
    }
    
} //End

// MARK: - TableView Delegate

extension FlightConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.flightConditionsTableView.dequeueReusableCell(withIdentifier: "FlightConditionsCell", for: indexPath) as? FlightConditionsTableViewCell else {
            NSLog("ERROR: FlightConditionsViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightConditionsCell\", if it's there it's not a FlightConditionsTableViewCell.")
            return UITableViewCell()
        }
        
        if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
            cell.setUpViews(crewMember: crewMember)
        }
        
        return cell
    }
    
} //End
