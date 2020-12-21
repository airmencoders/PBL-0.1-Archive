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
<<<<<<< HEAD
    
    // MARK: - Properties
    
    var flightTimeCells = [FlightTimeTableViewCell]()
    var isEditingTime = false
=======
>>>>>>> f874b18cb5fbb78aa75dcb4fd57fcd7221abe2b6
    
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
    
<<<<<<< HEAD
    func updateCells(toEditing: Bool) {
        for cell in flightTimeCells {
            cell.primary.isUserInteractionEnabled = toEditing
            cell.secondary.isUserInteractionEnabled = toEditing
            cell.instructor.isUserInteractionEnabled = toEditing
            cell.evaluator.isUserInteractionEnabled = toEditing
            cell.other.isUserInteractionEnabled = toEditing
            cell.time.isUserInteractionEnabled = toEditing
            cell.srty.isUserInteractionEnabled = toEditing
            if toEditing {
                cell.primary.borderStyle = .roundedRect
                cell.secondary.borderStyle = .roundedRect
                cell.instructor.borderStyle = .roundedRect
                cell.evaluator.borderStyle = .roundedRect
                cell.other.borderStyle = .roundedRect
                cell.time.borderStyle = .roundedRect
                cell.srty.borderStyle = .roundedRect
            } else {
                cell.primary.borderStyle = .none
                cell.secondary.borderStyle = .none
                cell.instructor.borderStyle = .none
                cell.evaluator.borderStyle = .none
                cell.other.borderStyle = .none
                cell.time.borderStyle = .none
                cell.srty.borderStyle = .none
                
                guard let crewMember = cell.crewMember else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.crewMember undefined.")
                    return
                }
                
                guard let primary = cell.primary.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.primary.text undefined.")
                    return
                }
                guard let secondary = cell.secondary.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.secondary.text undefined.")
                    return
                }
                guard let instructor = cell.instructor.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.instructor.text undefined.")
                    return
                }
                guard let evaluator = cell.evaluator.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.evaluator.text undefined.")
                    return
                }
                guard let other = cell.other.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.other.text undefined.")
                    return
                }
                guard let time = cell.time.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.time.text undefined.")
                    return
                }
                guard let srty = cell.srty.text else {
                    NSLog("ERROR: FlightTimeViewController: updateCells() cell.srty.text undefined.")
                    return
                }
                
                Form781Controller.shared.updateCrewMemberTime(crewMember: crewMember, primary: primary, secondary: secondary, instructor: instructor, evaluator: evaluator, other: other, time: time, srty: srty)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        isEditingTime.toggle()
        if isEditingTime {
            editButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            updateCells(toEditing: true)
        } else {
            editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
            updateCells(toEditing: false)
        }
=======
    // MARK: - Actions
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
>>>>>>> f874b18cb5fbb78aa75dcb4fd57fcd7221abe2b6
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
            cell.crewMember = crewMember
            cell.setUpViews(crewMember: crewMember)
        }
        //array replace index with cell at indexPath.row
        flightTimeCells.append(cell)
        
        return cell
    }
    
} //End
