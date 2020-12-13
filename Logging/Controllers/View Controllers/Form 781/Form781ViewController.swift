//
//  FlightListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/27/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit
import Foundation

class Form781ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var missionDateLabel: UILabel!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var aircrewListView: UIView!
    @IBOutlet weak var missionDataView: UIView!
    @IBOutlet weak var aircrewDataView: UIView!
    
    // MARK: - Properties
    
    var firstTimeToMissionData = true

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        guard let form = Form781Controller.shared.getCurrentForm() else {
            return
        }
        missionDateLabel.text = "MISSION \(form.date)"
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset: UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    // MARK: - Actions
    
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        Helper.exportPDF()
    }
        
    @IBAction func printButtonTapped(_ sender: UIButton) {
        Helper.printFormFunc()
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        // resign first responder in container view
    }
    
} //End

// MARK: - Delegates

extension Form781ViewController: MainViewControllerDelegate {
    
    func missionDataButtonTapped() {
        missionDataView.isHidden = false
        aircrewListView.isHidden = true
        aircrewDataView.isHidden = true
        if firstTimeToMissionData {
            dimView.isHidden = false
        }
    }
    
    func aircrewListButtonTapped() {
        missionDataView.isHidden = true
        aircrewListView.isHidden = false
        aircrewDataView.isHidden = true
        dimView.isHidden = true
    }
    
    func aircrewDataButtonTapped() {
        missionDataView.isHidden = true
        aircrewListView.isHidden = true
        aircrewDataView.isHidden = false
        dimView.isHidden = true
    }
    
} //End

extension Form781ViewController: AircrewViewControllerDelegate, MissionDataViewControllerDelegate, AircrewDataViewControllerDelegate {
    
    func updateFirstTimeToMissionData() {
        firstTimeToMissionData = false
    }
    
    func updateDimView(toHidden: Bool) {
        toHidden ? (dimView.isHidden = true) : (dimView.isHidden = false)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAircrewVC" {
            guard let destinationVC = segue.destination as? AircrewViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToAircrewVC\" destination should be AircrewViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
        }
        if segue.identifier == "ToMissionDataVC" {
            guard let destinationVC = segue.destination as? MissionDataViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToMissionDataVC\" destination should be MissionDataViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
        }
        if segue.identifier == "ToAircrewDataVC" {
            guard let destinationVC = segue.destination as? AircrewDataViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToAircrewDataVC\" destination should be AircrewDataViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
        }
        NSLog("ERROR: FlightListViewController prepare(for: - Unknown identifier '\(segue.destination)'")
    }
    
} //End
