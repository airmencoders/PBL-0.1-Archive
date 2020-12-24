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
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - Properties
    
    var flightConditionsCells = [FlightConditionsTableViewCell]()
    var isEditingConditions = false
    
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
        flightConditionsTableView.delegate = self
        flightConditionsTableView.dataSource = self
        currentFormChanged()
    }
    
    @objc func currentFormChanged() {
        flightConditionsTableView.reloadData()
    }
    
    func updateCells(toEditing: Bool) {
        for cell in flightConditionsCells {
            cell.night.isUserInteractionEnabled = toEditing
            cell.ins.isUserInteractionEnabled = toEditing
            cell.simIns.isUserInteractionEnabled = toEditing
            cell.nvg.isUserInteractionEnabled = toEditing
            cell.combatTime.isUserInteractionEnabled = toEditing
            cell.combatSrty.isUserInteractionEnabled = toEditing
            cell.combatSptTime.isUserInteractionEnabled = toEditing
            cell.combatSptSrty.isUserInteractionEnabled = toEditing
            cell.resv.isUserInteractionEnabled = toEditing
            if toEditing {
                cell.night.borderStyle = .roundedRect
                cell.ins.borderStyle = .roundedRect
                cell.simIns.borderStyle = .roundedRect
                cell.nvg.borderStyle = .roundedRect
                cell.combatTime.borderStyle = .roundedRect
                cell.combatSrty.borderStyle = .roundedRect
                cell.combatSptTime.borderStyle = .roundedRect
                cell.combatSptSrty.borderStyle = .roundedRect
                cell.resv.borderStyle = .roundedRect
            } else {
                cell.night.borderStyle = .none
                cell.ins.borderStyle = .none
                cell.simIns.borderStyle = .none
                cell.nvg.borderStyle = .none
                cell.combatTime.borderStyle = .none
                cell.combatSrty.borderStyle = .none
                cell.combatSptTime.borderStyle = .none
                cell.combatSptSrty.borderStyle = .none
                cell.resv.borderStyle = .none
                
                guard let crewMember = cell.crewMember else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.crewMember undefined.")
                    return
                }
                
                guard let nightPSIE = cell.night.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.nightPSIE.text undefined.")
                    return
                }
                guard let insPIE = cell.ins.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.insPIE.text undefined.")
                    return
                }
                guard let simIns = cell.simIns.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.simIns.text undefined.")
                    return
                }
                guard let nvg = cell.nvg.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.nvg.text undefined.")
                    return
                }
                guard let combatTime = cell.combatTime.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.combatTime.text undefined.")
                    return
                }
                guard let combatSrty = cell.combatSrty.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.combatSrty.text undefined.")
                    return
                }
                guard let combatSptTime = cell.combatSptTime.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.combatSptTime.text undefined.")
                    return
                }
                guard let combatSptSrty = cell.combatSptSrty.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.combatSptSrty.text undefined.")
                    return
                }
                guard let resvStatus = cell.resv.text else {
                    NSLog("ERROR: FlightConditionsViewController: updateCells() cell.resvStatus.text undefined.")
                    return
                }
                
                Form781Controller.shared.updateCrewMemberConditions(crewMember: crewMember, nightPSIE: nightPSIE, insPIE: insPIE, simIns: simIns, nvg: nvg, combatTime: combatTime, combatSrty: combatSrty, combatSptTime: combatSptTime, combatSptSrty: combatSptSrty, resvStatus: resvStatus)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        isEditingConditions.toggle()
        if isEditingConditions {
            editButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            updateCells(toEditing: true)
        } else {
            editButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
            updateCells(toEditing: false)
        }
    }
    
} //End

// MARK: - TableView Delegate

extension FlightConditionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.getCurrentForm()?.crewMembers.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.flightConditionsTableView.dequeueReusableCell(withIdentifier: "FlightConditionsCell", for: indexPath) as? FlightConditionsTableViewCell else {
            NSLog("ERROR: FlightConditionsViewController: tableView(cellForRowAt:) - dequeue failed for \"FlightConditionsCell\", if it's there, it's not a FlightConditionsTableViewCell.")
            return UITableViewCell()
        }
        
        if let crewMember = Form781Controller.shared.getCurrentForm()?.crewMembers[indexPath.row] {
            cell.crewMember = crewMember
            cell.setUpViews(crewMember: crewMember)
        }
        flightConditionsCells.append(cell)
        
        return cell
    }
    
} //End
