//
//  ViewController.swift
//  PrivateInvestigator
//
//  Created by apple on 6/19/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnBookPrivateEye: UIButton!
    @IBOutlet weak var btnRegisterPrivateEye: UIButton!
    @IBOutlet weak var lblVideoBookPrivateEye: UILabel!
    @IBOutlet weak var lblVideoRegisterPrivateEye: UILabel!
    
    var userRoleId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func clickBtnBookPrivateEye(_ sender: Any) {
        userRoleId = 1
        performSegue(withIdentifier: "toSignUpGeneral", sender: self)
    }
    
    @IBAction func clickBtnRegisterPrivateEye(_ sender: Any) {
        userRoleId = 2
        performSegue(withIdentifier: "toSignUpGeneral", sender: self)
    }
    
    @IBAction func testPay(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let payViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentVC
        payViewController.paymentPurpose = "Registration Fee"
        payViewController.paymentDescription = "This is the registration chrage for private eye to use the app."
        payViewController.currency = "AUD"
        payViewController.amount = 55.0
        self.present(payViewController, animated: true, completion: nil)
    }
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnBookPrivateEye.roundAllCorners(radius: 5.0)
        btnRegisterPrivateEye.roundAllCorners(radius: 5.0)
        btnBookPrivateEye.addBorder(color: UIColor.black.cgColor, width: 1.5)
        btnRegisterPrivateEye.addBorder(color: UIColor.black.cgColor, width: 1.5)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignUpGeneral" {
            let destVC:RegisterAndPhoneVerificationVC = segue.destination as! RegisterAndPhoneVerificationVC
            destVC.userRoleID = userRoleId
            destVC.forRegister = true
        }
        
    }


}

