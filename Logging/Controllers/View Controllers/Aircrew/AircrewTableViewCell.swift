//
//  AircrewTableViewCell.swift
//  Logging
//
//  Created by Bethany Morris on 10/22/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol AircrewTableViewCellDelegate: class {
    func editButtonTapped(cell: AircrewTableViewCell)
    func deleteButtonTapped(cell: AircrewTableViewCell)
}

class AircrewTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ssnLabel: UILabel!
    @IBOutlet weak var flyingOriginLabel: UILabel!
    @IBOutlet weak var flightAuthDutyCodeLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: AircrewTableViewCellDelegate?
    var crewMember: CrewMember?
    
    // MARK: - Methods and Actions
    
    func setUpViews(crewMember: CrewMember) {
        nameLabel.text = "\(crewMember.lastName), \(crewMember.firstName)"
        ssnLabel.text = crewMember.ssnLast4
        flyingOriginLabel.text = crewMember.flyingOrigin
        flightAuthDutyCodeLabel.text = crewMember.flightAuthDutyCode
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        delegate?.editButtonTapped(cell: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        delegate?.deleteButtonTapped(cell: self)
    }
    
} //End
