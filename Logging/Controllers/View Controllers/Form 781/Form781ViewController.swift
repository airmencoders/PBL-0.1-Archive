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
    func addFlightButtonTapped()
    func editFlightButtonTapped(flight: Flight)
    func addAircrewButtonTapped()
    func editAircrewButtonTapped(crewMember: CrewMember)
}

protocol Form781ViewControllerMissionDataDelegate: class {
    func updateMissionDataLabels()
}

protocol Form781ViewControllerFlightSeqDelegate: class {
    func reloadFlightSeqTableView()
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
    weak var missionDataDelegate: Form781ViewControllerMissionDataDelegate?
    weak var flightSeqDelegate: Form781ViewControllerFlightSeqDelegate?
    weak var aircrewDelegate: Form781ViewControllerAircrewDelegate?

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
        
        FlightListActivityController.share(title: "Form 781", message: "Current 781", pdfDoc: pdfPulled, on: self, frame: sender.frame)
    }
        
    @IBAction func printButtonTapped(_ sender: UIButton) {
        Helper.print871()
    }
    
} //End

// MARK: - Delegates

extension Form781ViewController: MainViewControllerDelegate {
    
    func missionDataButtonTapped() {
        missionDataView.isHidden = false
        aircrewListView.isHidden = true
        aircrewDataView.isHidden = true
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
    }
    
    func updateMissionDataLabels() {
        missionDataDelegate?.updateMissionDataLabels()
    }
    
    func reloadFlightSeqTableView() {
        flightSeqDelegate?.reloadFlightSeqTableView()
    }
    
    func reloadAircrewTableView() {
        aircrewDelegate?.reloadAircrewTableView()
    }
    
} //End

extension Form781ViewController: MissionDataViewControllerDelegate, AircrewViewControllerDelegate, AircrewDataViewControllerDelegate {
    
    func editMissionDataButtonTapped() {
        mainViewDelegate?.editMissionDataButtonTapped()
    }
    
    func addFlightButtonTapped() {
        mainViewDelegate?.addFlightButtonTapped()
    }

    func editFlightButtonTapped(flight: Flight) {
        mainViewDelegate?.editFlightButtonTapped(flight: flight)
    }
    
    func addAircrewButtonTapped() {
        mainViewDelegate?.addAircrewButtonTapped()
    }
    
    func editAircrewButtonTapped(crewMember: CrewMember) {
        mainViewDelegate?.editAircrewButtonTapped(crewMember: crewMember)
    }
        
} //End

extension Form781ViewController {
    
    // Setting delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToMissionDataVC" {
            guard let destinationVC = segue.destination as? MissionDataViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToMissionDataVC\" destination should be MissionDataViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
            missionDataDelegate = destinationVC
        }
        if segue.identifier == "ToAircrewVC" {
            guard let destinationVC = segue.destination as? AircrewViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToAircrewVC\" destination should be AircrewViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
            aircrewDelegate = destinationVC
        }
        if segue.identifier == "ToAircrewDataVC" {
            guard let destinationVC = segue.destination as? AircrewDataViewController else {
                NSLog("ERROR: FlightListViewController prepare(for: identifier \"ToAircrewDataVC\" destination should be AircrewDataViewController. destination = \(segue.destination)")
                return
            }
            destinationVC.delegate = self
            flightSeqDelegate = destinationVC
        }
        NSLog("ERROR: FlightListViewController prepare(for: - Unknown identifier '\(segue.destination)'")
    }
    
} //End

struct FlightListActivityController {
    
    static func share(title: String, message: String, pdfDoc: PDFDocument, on vc: UIViewController, frame: CGRect) {
        let formattedMessage = "\n\(message)"
        
        let objectsToShare = [
            title,
            formattedMessage,
            pdfDoc.dataRepresentation()!
        ] as [Any]
        
        let avc = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        avc.setValue(title, forKey: "Subject")
        
        if let avcppc = avc.popoverPresentationController {
            avcppc.sourceView = vc.view;
            avcppc.sourceRect = frame
        }

        vc.present(avc, animated: true, completion: nil)
        if let popOver = avc.popoverPresentationController {
            popOver.sourceView = vc.view
        }
    }
    
} //End
