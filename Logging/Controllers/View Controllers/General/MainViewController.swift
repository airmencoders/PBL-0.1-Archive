//
//  MainViewController.swift
//  Logging
//
//  Created by Bethany Morris on 12/11/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate: class {
    func missionDataButtonTapped()
    func aircrewListButtonTapped()
    func aircrewDataButtonTapped()
    func updateMissionDataLabels()
    func reloadFlightSeqTableView()
    func reloadAircrewTableView()
}

protocol MainViewControllerMissionDataPopUpDelegate: class {
    func editMissionDataButtonTapped()
}

protocol MainViewControllerFlightSeqPopUpDelegate: class {
    func editFlightButtonTapped(flight: Flight)
}

protocol MainViewControllerAircrewPopUpDelegate: class {
    func editAircrewButtonTapped(crewMember: CrewMember)
}

class MainViewController: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var form781View: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var headerDimView: UIView!
    @IBOutlet weak var missionDataPopUp: UIView!
    @IBOutlet weak var flightSeqPopUp: UIView!
    @IBOutlet weak var aircrewPopUp: UIView!
    
    @IBOutlet weak var flightSeqPopUpBottom: NSLayoutConstraint!
    @IBOutlet weak var dimViewBottom: NSLayoutConstraint!
    
    // MARK: - Properties
    
    weak var delegate: MainViewControllerDelegate?
    weak var missionDataDelegate: MainViewControllerMissionDataPopUpDelegate?
    weak var flightSeqDelegate: MainViewControllerFlightSeqPopUpDelegate?
    weak var aircrewDelegate: MainViewControllerAircrewPopUpDelegate?
    
    var isMenuOpen = true
    var sideMenuClosedConstraintPortrait = -(UIScreen.main.bounds.width/6)
    var sideMenuClosedConstraintLandscape = -(UIScreen.main.bounds.width/4.5)
    
    var isStartingInPortrait = true
    var flightSeqPopUpLandscapeConstant = (UIScreen.main.bounds.height/7)
    
    var statusBarOrientation: UIInterfaceOrientation {
        get {
            guard let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation else {
                #if DEBUG
                fatalError("Could not obtain UIInterfaceOrientation from a valid windowScene")
                #else
                // Just fake it with a default setting.
                return UIInterfaceOrientation.portrait
                #endif
            }
            return orientation
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - Methods
    
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func rotated() {
        if UIApplication.shared.statusBarOrientation.isPortrait {
            NSLog("Portrait")
            if !isMenuOpen {
                sideMenuLeadingConstraint.constant = sideMenuClosedConstraintPortrait
            }
            let contentInset: UIEdgeInsets = UIEdgeInsets.zero
            scrollView.contentInset = contentInset
            if !isStartingInPortrait {
                flightSeqPopUpBottom.constant += flightSeqPopUpLandscapeConstant
                dimViewBottom.constant += flightSeqPopUpLandscapeConstant
            }
        } else {
            NSLog("Landscape")
            if !isMenuOpen {
                sideMenuLeadingConstraint.constant = sideMenuClosedConstraintLandscape
            }
            var contentInset: UIEdgeInsets = self.scrollView.contentInset
            contentInset.bottom = flightSeqPopUpLandscapeConstant
            scrollView.contentInset = contentInset
            flightSeqPopUpBottom.constant -= flightSeqPopUpLandscapeConstant
            dimViewBottom.constant -= flightSeqPopUpLandscapeConstant
            isStartingInPortrait = false
        }
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else {
            return
        }
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        
        if UIDevice.current.orientation.isPortrait {
            contentInset.bottom = keyboardFrame.size.height
        } else {
            contentInset.bottom = keyboardFrame.size.height + flightSeqPopUpLandscapeConstant
        }
        
        scrollView.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {
        var contentInset: UIEdgeInsets = UIEdgeInsets.zero
        contentInset.bottom = flightSeqPopUpLandscapeConstant
        scrollView.contentInset = contentInset
    }
    
    func updateDimViews(toHidden: Bool) {
        dimView.isHidden = toHidden
        headerDimView.isHidden = toHidden
    }
    
    func closePopUp() {
        updateDimViews(toHidden: true)
        missionDataPopUp.isHidden = true
        flightSeqPopUp.isHidden = true
        aircrewPopUp.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func helpButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        
    }
    
} //End

// MARK: - Delegates

extension MainViewController: SideMenuViewControllerDelegate {
    
    func menuButtonTapped(isOpen: Bool) {
        isMenuOpen.toggle()
        if statusBarOrientation.isPortrait {
            isOpen ? (sideMenuLeadingConstraint.constant = 0) : (sideMenuLeadingConstraint.constant = sideMenuClosedConstraintPortrait)
        }
        if statusBarOrientation.isLandscape{
            isOpen ? (sideMenuLeadingConstraint.constant = 0) : (sideMenuLeadingConstraint.constant = sideMenuClosedConstraintLandscape)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func overviewButtonTapped() {
        form781View.isHidden = true
        overviewView.isHidden = false
    }
    
    func missionDataButtonTapped() {
        form781View.isHidden = false
        overviewView.isHidden = true
        delegate?.missionDataButtonTapped()
    }
    
    func aircrewListButtonTapped() {
        form781View.isHidden = false
        overviewView.isHidden = true
        delegate?.aircrewListButtonTapped()
    }
    
    func aircrewDataButtonTapped() {
        form781View.isHidden = false
        overviewView.isHidden = true
        delegate?.aircrewDataButtonTapped()
    }
    
} //End

extension MainViewController: Form781ViewControllerMainViewDelegate {
    
    func editMissionDataButtonTapped() {
        updateDimViews(toHidden: false)
        missionDataPopUp.isHidden = false
        flightSeqPopUp.isHidden = true
        aircrewPopUp.isHidden = true
        missionDataDelegate?.editMissionDataButtonTapped()
    }
    
    func addFlightButtonTapped() {
        updateDimViews(toHidden: false)
        missionDataPopUp.isHidden = true
        flightSeqPopUp.isHidden = false
        aircrewPopUp.isHidden = true
    }
    
    func editFlightButtonTapped(flight: Flight) {
        updateDimViews(toHidden: false)
        missionDataPopUp.isHidden = true
        flightSeqPopUp.isHidden = false
        aircrewPopUp.isHidden = true
        flightSeqDelegate?.editFlightButtonTapped(flight: flight)
    }
    
    func addAircrewButtonTapped() {
        updateDimViews(toHidden: false)
        missionDataPopUp.isHidden = true
        flightSeqPopUp.isHidden = true
        aircrewPopUp.isHidden = false
    }
    
    func editAircrewButtonTapped(crewMember: CrewMember) {
        updateDimViews(toHidden: false)
        missionDataPopUp.isHidden = true
        flightSeqPopUp.isHidden = true
        aircrewPopUp.isHidden = false
        aircrewDelegate?.editAircrewButtonTapped(crewMember: crewMember)
    }
    
} //End

extension MainViewController: MissionDataPopUpViewControllerDelegate {

    func closeMissionDataPopUp() {
        delegate?.updateMissionDataLabels()
        delegate?.reloadFlightSeqTableView()
        closePopUp()
    }

} //End

extension MainViewController: FlightSeqPopUpViewControllerDelegate {
    
    func closeFlightSeqPopUp() {
        delegate?.reloadFlightSeqTableView()
        closePopUp()
    }
    
} //End

extension MainViewController: AircrewPopUpViewControllerDelegate {
    
    func closeAircrewPopUp() {
        delegate?.reloadAircrewTableView()
        closePopUp()
    }
    
} //End

extension MainViewController {
    
    // Setting delegates
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToSideMenuVC" {
            guard let destinationVC = segue.destination as? SideMenuViewController else {
                return
            }
            destinationVC.delegate = self
        }
        if segue.identifier == "ToForm781VC" {
            guard let destinationVC = segue.destination as? Form781ViewController else {
                return
            }
            self.delegate = destinationVC
            destinationVC.mainViewDelegate = self
        }
        if segue.identifier == "ToMissionDataPopUpVC" {
            guard let destinationVC = segue.destination as? MissionDataPopUpViewController else {
                return
            }
            destinationVC.delegate = self
            missionDataDelegate = destinationVC
        }
        if segue.identifier == "ToFlightSeqPopUpVC" {
            guard let destinationVC = segue.destination as? FlightSeqPopUpViewController else {
                return
            }
            destinationVC.delegate = self
            flightSeqDelegate = destinationVC
        }
        if segue.identifier == "ToAircrewPopUpVC" {
            guard let destinationVC = segue.destination as? AircrewPopUpViewController else {
                return
            }
            destinationVC.delegate = self
            aircrewDelegate = destinationVC
        }
    }
    
} //End
