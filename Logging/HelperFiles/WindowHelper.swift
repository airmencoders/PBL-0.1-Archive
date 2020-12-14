//
//  WindowHelper.swift
//  Logging
//
//  Created by Pete Misik on 12/14/20.
//  Copyright © 2020 Christian Brechbuhl. All rights reserved.
//

import UIKit

extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.visibleVC(viewController: self.rootViewController)
    }
    
    static func visibleVC(viewController: UIViewController?) -> UIViewController? {
//        if let navigationViewController = viewController as? UINavigationController {
//            return UIWindow.visibleVC(viewController: navigationViewController.visibleViewController)
//        } else if let tabBarVC = viewController as? UITabBarController {
//            return UIWindow.visibleVC(viewController: tabBarVC.selectedViewController)
//        } else {
        if let presentedViewController = viewController?.presentedViewController {
            return UIWindow.visibleVC(viewController: presentedViewController)
        } else {
            return viewController
        }
//        }
    }
}

public func visibleViewController() -> UIViewController? {
    UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.visibleViewController
}


