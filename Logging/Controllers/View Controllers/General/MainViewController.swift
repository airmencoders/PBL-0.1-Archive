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
    func reloadAircrewTableView()
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
    @IBOutlet weak var aircrewPopUp: UIView!
    
    // MARK: - Properties
    
    weak var delegate: MainViewControllerDelegate?
    weak var aircrewDelegate: MainViewControllerAircrewPopUpDelegate?
    var isMenuOpen = true
    var sideMenuClosedConstraintPortrait = -(UIScreen.main.bounds.width/6)
    var sideMenuClosedConstraintLandscape = -(UIScreen.main.bounds.width/4.5)
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
        if UIDevice.current.orientation.isPortrait {
            NSLog("Portrait")
            if !isMenuOpen {
                sideMenuLeadingConstraint.constant = sideMenuClosedConstraintPortrait
            }
        } else {
            NSLog("Landscape")
            if !isMenuOpen {
                sideMenuLeadingConstraint.constant = sideMenuClosedConstraintLandscape
            }
        }
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
    
    func updateDimViews(toHidden: Bool) {
        dimView.isHidden = toHidden
        headerDimView.isHidden = toHidden
    }
    
    func closePopUp() {
        updateDimViews(toHidden: true)
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
    }
    
    func addFlightSeqButtonTapped() {
        updateDimViews(toHidden: false)
    }
    
    func editFlightSeqButtonTapped() {
        updateDimViews(toHidden: false)
    }
    
    func addAircrewButtonTapped() {
        updateDimViews(toHidden: false)
        aircrewPopUp.isHidden = false
    }
    
    func editAircrewButtonTapped(crewMember: CrewMember) {
        updateDimViews(toHidden: false)
        aircrewPopUp.isHidden = false
        aircrewDelegate?.editAircrewButtonTapped(crewMember: crewMember)
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
        if segue.identifier == "ToAircrewPopUpVC" {
            guard let destinationVC = segue.destination as? AircrewPopUpViewController else {
                return
            }
            destinationVC.delegate = self
            aircrewDelegate = destinationVC
        }
    }
    
} //End
