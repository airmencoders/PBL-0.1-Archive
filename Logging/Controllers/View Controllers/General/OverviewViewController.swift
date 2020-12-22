//
//  OverviewViewController.swift
//  Logging
//
//  Created by Bethany Morris on 10/23/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func printButtonTapped(_ sender: UIButton) {
        guard let form781 = Form781Controller.shared.getCurrentForm() else { return }
        form781.printPDF()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} //End
