//
//  AircrewDataViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/2/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewDataViewControllerDelegate: class {
    func updateDimView(toHidden: Bool)
}

class AircrewDataViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var flightSeqTableView: UITableView!
    @IBOutlet weak var flightTimeTableView: UITableView!
    
    @IBOutlet weak var primary: UITextField!
    @IBOutlet weak var secondary: UITextField!
    @IBOutlet weak var instructor: UITextField!
    @IBOutlet weak var evaluator: UITextField!
    @IBOutlet weak var other: UITextField!
    @IBOutlet weak var time: UITextField!
    @IBOutlet weak var srty: UITextField!

    @IBOutlet weak var nightPSIE: UITextField!
    @IBOutlet weak var insPIE: UITextField!
    @IBOutlet weak var simIns: UITextField!
    @IBOutlet weak var nvg: UITextField!
    @IBOutlet weak var combatTime: UITextField!
    @IBOutlet weak var combatSrty: UITextField!
    @IBOutlet weak var combatSptTime: UITextField!
    @IBOutlet weak var combatSptSrty: UITextField!
    @IBOutlet weak var resvStatus: UITextField!
    
    // MARK: - Properties
    
    weak var delegate: AircrewDataViewControllerDelegate?
//    var takeOffTimeString: String = " "
//    var landTimeString: String = " "
    
    // MARK: - Local variables
//    private var saveddateTextFieldText: String = ""

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        flightSeqTableView.delegate = self
        flightSeqTableView.dataSource = self
        flightTimeTableView.delegate = self
        flightTimeTableView.dataSource = self
    }

} //End

// MARK: - FlightTableViewCell Delegate

extension AircrewDataViewController: FlightTableViewCellDelegate {
    
    func editButtonTapped(cell: FlightTableViewCell) {
        
    }
    
    func deleteButtonTapped(cell: FlightTableViewCell) {
//        guard let form = Form781Controller.shared.forms.last,
//              let indexPath = flightSeqTableView.indexPath(for: cell) else { return }
//        let flight = form.flights[indexPath.row]
//        Form781Controller.shared.remove(flight: flight, from: form)
//        flightSeqTableView.reloadData()
//
//        updateGrandTotals(form: form)
    }
    
} //End

// MARK: - TableView Delegate

extension AircrewDataViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.flightTimeTableView {
            return Form781Controller.shared.forms.last?.crewMembers.count ?? 0
        }
        if tableView == self.flightSeqTableView {
            return Form781Controller.shared.forms.last?.flights.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.flightTimeTableView {
            guard let cell = self.flightTimeTableView.dequeueReusableCell(withIdentifier: "FlightTimeCell", for: indexPath) as? FlightTimeTableViewCell else { return UITableViewCell() }
            
            if let crewMember = Form781Controller.shared.forms.last?.crewMembers[indexPath.row] {
                cell.setUpViews(crewMember: crewMember)
            }
            
            return cell
        }
        if tableView == self.flightSeqTableView {
            guard let cell = self.flightSeqTableView.dequeueReusableCell(withIdentifier: "FlightCell", for: indexPath) as? FlightTableViewCell else { return UITableViewCell() }
            
            cell.delegate = self
            if let flight = Form781Controller.shared.forms.last?.flights[indexPath.row] {
                cell.setUpViews(flight: flight)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
} //End
