//
//  WorkerThread.swift
//  Logging
//
//  Created by Pete Misik on 12/18/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import Foundation
import UIKit


enum ThreadError: String, Error {
    case threadCrash = "The thread crashed.  Need to investigate"
}

struct WorkerThread {
    func generateThePDF(completed: @escaping (Result<String, ThreadError>) -> Void) {
        var success = true
        
        DispatchQueue.global(qos: .background).async {
            if Helper.exportPDF() {
                success = true
            } else {
                success = false
            }
            
            if success {
                completed(.success("Huzzah"))
            } else {
                completed(.failure(.threadCrash))
            }
        }
    }
    
    func genPDFInBackground(button: UIButton, controller: UIViewController) {
        generateThePDF { result in
            switch result {
            case .success(let string):
                DispatchQueue.main.async{
                    NSLog("\(string) we have a pdf ")
                    Helper.threadFinished(sender: button, controller: controller)
                }
                
            case .failure(let error):
                NSLog(error.rawValue)
            }
        }
    }
}
