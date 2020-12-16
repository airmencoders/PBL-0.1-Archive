//
//  AircrewViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/1/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewViewControllerDelegate: class {
    func addAircrewButtonTapped()
    func editAircrewButtonTapped(crewMember: CrewMember)
}

class AircrewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var aircrewTableView: UITableView!
    
    // MARK: - Properties
    
    var isEditingMember = false
    var crewMemberToEdit: CrewMember?
    weak var delegate: AircrewViewControllerDelegate?
    
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
        aircrewTableView.delegate = self
        aircrewTableView.dataSource = self
        currentFormChanged()
    }
    
    @objc func currentFormChanged() {
        aircrewTableView.reloadData()
    }

    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        delegate?.addAircrewButtonTapped()
    }
    
} //End

// MARK: - TableView Delegate

extension AircrewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.aircrewTableView.dequeueReusableCell(withIdentifier: "AircrewCell", for: indexPath) as? AircrewTableViewCell else {
            NSLog("ERROR: AircrewViewController: tableView(cellForRowAt:) - dequeue failed for \"AircrewCell\", if it's there it's not a AircrewTableViewCell.")
            return UITableViewCell()
        }
        
        cell.delegate = self
        if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
            cell.crewMember = crewMember
            cell.setUpViews(crewMember: crewMember)
        }
        
        return cell
    }
    
} //End

// MARK: - TableViewCell Delegate

extension AircrewViewController: AircrewTableViewCellDelegate {
    
    func editButtonTapped(cell: AircrewTableViewCell) {
        guard let crewMember = cell.crewMember else {
            NSLog("AircrewViewController: editButtonTapped() the cell \(cell) does not have a crewMember.")
            return
        }
        delegate?.editAircrewButtonTapped(crewMember: crewMember)
    }

    func deleteButtonTapped(cell: AircrewTableViewCell) {
        guard let form = Form781Controller.shared.getCurrentForm() else {
            NSLog("AircrewViewController: deleteButtonTapped(cell: - there is no current form, returning.")
            return
        }
        guard let indexPath = aircrewTableView.indexPath(for: cell) else {
            NSLog("ERROR: AircrewViewController: deleteButtonTapped(cell: - The cell \(cell) is not in the table view..")
            return
        }
        let crewMember = form.crewMembers[indexPath.row]
        Form781Controller.shared.remove(crewMember: crewMember, from: form)
    }
    
} //End

// MARK: - Delegates

extension AircrewViewController: Form781ViewControllerAircrewDelegate {
    
    func reloadAircrewTableView() {
        aircrewTableView.reloadData()
    }

} //End
