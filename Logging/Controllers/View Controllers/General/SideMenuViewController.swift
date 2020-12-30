//
//  SideMenuViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/11/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol SideMenuViewControllerDelegate: class {
    func menuButtonTapped(isOpen: Bool)
    func overviewButtonTapped()
    func missionDataButtonTapped()
    func aircrewListButtonTapped()
    func aircrewDataButtonTapped()
}

class SideMenuViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var overviewButton: PBLSideMenuButton!
    @IBOutlet weak var missionDataButton: PBLSideMenuButton!
    @IBOutlet weak var aircrewListButton: PBLSideMenuButton!
    @IBOutlet weak var aircrewDataButton: PBLSideMenuButton!
    @IBOutlet weak var daysTableView: UITableView!
    
    // MARK: - Properties
    
    weak var delegate: SideMenuViewControllerDelegate?
    var isMenuOpen = true
    var dayCells = [DayTableViewCell]()
    
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
        daysTableView.delegate = self
        daysTableView.dataSource = self
        overviewButton.isSelected = true
        updateButtons()
        currentFormChanged()
    }
    
    func updateButtons() {
        overviewButton.isSelected ? overviewButton.updateUI(toSelected: true) : overviewButton.updateUI(toSelected: false)
        missionDataButton.isSelected ? missionDataButton.updateUI(toSelected: true) : missionDataButton.updateUI(toSelected: false)
        aircrewListButton.isSelected ? aircrewListButton.updateUI(toSelected: true) : aircrewListButton.updateUI(toSelected: false)
        aircrewDataButton.isSelected ? aircrewDataButton.updateUI(toSelected: true) : aircrewDataButton.updateUI(toSelected: false)
    }
    
    func deselectAllButtons() {
        overviewButton.isSelected = false
        missionDataButton.isSelected = false
        aircrewListButton.isSelected = false
        aircrewDataButton.isSelected = false
    }
    
    func updateButtonVisibility(toHidden: Bool) {
        overviewButton.isHidden = toHidden
        missionDataButton.isHidden = toHidden
        aircrewListButton.isHidden = toHidden
        aircrewDataButton.isHidden = toHidden
        daysTableView.isHidden = toHidden
    }
    
    // MARK: - Actions
    
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        isMenuOpen.toggle()
        delegate?.menuButtonTapped(isOpen: isMenuOpen)
        if isMenuOpen {
            menuButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            updateButtonVisibility(toHidden: false)
        } else {
            menuButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            updateButtonVisibility(toHidden: true)
        }
    }
    
    @IBAction func overviewButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        overviewButton.isSelected = true
        updateButtons()
        delegate?.overviewButtonTapped()
    }
    
    @IBAction func missionDataButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        missionDataButton.isSelected = true
        updateButtons()
        delegate?.missionDataButtonTapped()
    }
    
    @IBAction func aircrewListButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        aircrewListButton.isSelected = true
        updateButtons()
        delegate?.aircrewListButtonTapped()
    }
    
    @IBAction func aircrewDataButtonTapped(_ sender: UIButton) {
        deselectAllButtons()
        aircrewDataButton.isSelected = true
        updateButtons()
        delegate?.aircrewDataButtonTapped()
    }
    
    @IBAction func addDayButtonTapped(_ sender: UIButton) {
        Form781Controller.shared.addNewForm()
    }

    @objc func currentFormChanged() {
        let numberOfForms = Form781Controller.shared.numberOfForms()
        if dayCells.count != numberOfForms {
            dayCells = [DayTableViewCell](repeating: DayTableViewCell(), count: numberOfForms)
        }
        daysTableView.reloadData()
    }

} //End

// MARK: - TableView Delegate

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Form781Controller.shared.numberOfForms()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.daysTableView.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath) as? DayTableViewCell else {
            NSLog("ERROR: SideMenuViewController: tableView(cellForRowAt:) - dequeue failed for \"DayCell\", if it's there it's not a DayTableViewCell.")
            return UITableViewCell()
        }

        let date = Form781Controller.shared.getDateStringForForm(at: indexPath.row)
        cell.setUpViews(date: date)

        if indexPath.row == Form781Controller.shared.currentFormIndex {
            cell.dayBackgroundView.backgroundColor = .slate
            cell.dayLabel.textColor = .white
        } else {
            cell.dayBackgroundView.backgroundColor = .haze
            cell.dayLabel.textColor = .slate
        }

        dayCells.remove(at: indexPath.row)
        dayCells.insert(cell, at: indexPath.row)
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Form781Controller.shared.setCurrentFormIndex(indexPath.row)
    }
    
} //End
