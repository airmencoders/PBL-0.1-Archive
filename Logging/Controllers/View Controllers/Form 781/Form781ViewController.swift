//
//  FlightListViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/27/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit
import PDFKit
import Foundation

protocol Form781ViewControllerMainViewDelegate: class {
    func editMissionDataButtonTapped()
    func addFlightSeqButtonTapped()
    func editFlightSeqButtonTapped()
    func addAircrewButtonTapped()
    func editAircrewButtonTapped(crewMember: CrewMember)
}

protocol Form781ViewControllerAircrewDelegate: class {
    func reloadAircrewTableView()
}

class Form781ViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var missionDateLabel: UILabel!
    
    @IBOutlet weak var aircrewListView: UIView!
    @IBOutlet weak var missionDataView: UIView!
    @IBOutlet weak var aircrewDataView: UIView!
    
    // MARK: - Properties
    
    weak var mainViewDelegate: Form781ViewControllerMainViewDelegate?
    weak var aircrewDelegate: Form781ViewControllerAircrewDelegate?
    var missionDataDimViewHidden = false
    var aircrewListDimViewHidden = true
    var aircrewDataDimViewHidden = true

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
        // Load the PDF
        
        NSLog("***** Send button tapped *****")
        let _ = Helper.exportPDF()
        NSLog("***** PDF Saved to disc *****")
        // Alerts.showPDFCreation(on: self)
        let pdfPulled: PDFDocument = Helper.loadPDFFromDisc()
        NSLog("***** PDF Loaded *****")
        
        FlightListActivityController.share(title: "Form 781", message: "Current 781", pdfDoc: pdfPulled, on: self)
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
        //missionDataDimViewHidden ? (dimView.isHidden = true) : (dimView.isHidden = false)
    }
    
    func aircrewListButtonTapped() {
        missionDataView.isHidden = true
        aircrewListView.isHidden = false
        aircrewDataView.isHidden = true
    }
    
    func aircrewDataButtonTapped() {
        missionDataView.isHidden = true
        aircrewListView.isHidden = true
        aircrewDataView.isHidden = false
        //aircrewDataDimViewHidden ? (dimView.isHidden = true) : (dimView.isHidden = false)
    }
    
    func reloadAircrewTableView() {
        aircrewDelegate?.reloadAircrewTableView()
    }
    
} //End

extension Form781ViewController: MissionDataViewControllerDelegate, AircrewViewControllerDelegate, AircrewDataViewControllerDelegate {
    
    func addAircrewButtonTapped() {
        mainViewDelegate?.addAircrewButtonTapped()
    }
    
    func editAircrewButtonTapped(crewMember: CrewMember) {
        mainViewDelegate?.editAircrewButtonTapped(crewMember: crewMember)
    }
    
    func updateMissionDataDimViewHidden(toHidden: Bool) {
        toHidden ? (missionDataDimViewHidden = true) : (missionDataDimViewHidden = false)
    }
    
    func updateAircrewDataDimViewHidden(toHidden: Bool) {
        toHidden ? (aircrewDataDimViewHidden = true) : (aircrewDataDimViewHidden = false)
    }
    
    func updateDimView(toHidden: Bool) {
        //toHidden ? (dimView.isHidden = true) : (dimView.isHidden = false)
    }
        
} //End

extension Form781ViewController {
    
    // Setting delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToAircrewVC" {
            guard let destinationVC = segue.destination as? AircrewViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToAircrewVC\" destination should be AircrewViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
            aircrewDelegate = destinationVC
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

struct FlightListActivityController {
    
    static func share(title: String, message: String, pdfDoc: PDFDocument, on vc: UIViewController) {
        let formattedMessage = "\n\(message)"
        
        let objectsToShare = [
            title,
            formattedMessage,
            pdfDoc.dataRepresentation()!
        ] as [Any]
        
        let avc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        avc.setValue(title, forKey: "Subject")
        
        vc.present(avc, animated: true, completion: nil)
        if let popOver = avc.popoverPresentationController {
            popOver.sourceView = vc.view
        }
    }
    
} //End
