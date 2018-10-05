//
//  UIViewControllerExtension.swift
//  PrivateInvestigator
//
//  Created by apple on 6/29/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setBackButton(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        item.tintColor = UIColor.white
        viewController.navigationItem.backBarButtonItem = item
        viewController.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSettingsAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { _ in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)!
            UIApplication.shared.open(settingsUrl)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func showActivityIndicator() -> Bool {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor.darkGray
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.startAnimating()
        activityIndicator.tag = 99
        for subview in self.view.subviews {
            if subview.tag == 99 {
                return false
            }
        }
        self.view.addSubview(activityIndicator)
        self.view.isUserInteractionEnabled = false
        return true
    }
    
    func hideActivityIndicator() {
        let activityIndicator = self.view.viewWithTag(99) as? UIActivityIndicatorView
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
    
}
