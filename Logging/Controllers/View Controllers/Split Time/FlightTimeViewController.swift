//
//  FlightTimeViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/29/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class FlightTimeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var flightTimeTableView: UITableView!
    @IBOutlet weak var editButton: UIButton!
    
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
        flightTimeTableView.delegate = self
        flightTimeTableView.dataSource = self
        currentFormChanged()
    }
    
    @objc func currentFormChanged() {
        flightTimeTableView.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
    }
    
} //End

// MARK: - TableView Delegate

extension FlightTimeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.flightTimeTableView.dequeueReusableCell(withIdentifier: "FlightTimeCell", for: indexPath) as? FlightTimeTableViewCell else {
            NSLog("ERROR: FlightTimeViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightTimeCell\", if it's there it's not a FlightTimeTableViewCell.")
            return UITableViewCell()
        }
        
        if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
            cell.setUpViews(crewMember: crewMember)
        }
        
        return cell
    }
    
} //End
