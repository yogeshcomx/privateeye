//
//  PaymentPIRegistrationVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/9/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class PaymentPIRegistrationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    @IBAction func clickBtnPay(_ sender: Any) {
        UserDefaults.standard.set(completedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
        let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.loadViewController(storyBoard: "PrivateInvestigator", viewController: nil)
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        
    }

}
