//
//  LoginVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/29/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LoginVC: UIViewController {

    @IBOutlet weak var txtEmailPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    
    @IBAction func clickBtnSignIn(_ sender: Any) {
        if !StringManager.sharedInstance.validateMobile(text: txtEmailPhone.text!) {
            showAlert(title: "Error", message: "Please enter valid Mobile Number")
        } else if !StringManager.sharedInstance.validatePassword(text: txtPassword.text!) {
            showAlert(title: "Error", message: "Please enter valid Password")
        } else {
            login()
            
//            if txtEmailPhone.text == "4455667788" && txtPassword.text == "abcd1234" {
//                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.loadViewController(storyBoard: "Booker", viewController: nil)
//            } else if txtEmailPhone.text == "3344556677" && txtPassword.text == "1234abcd" {
//                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
//                appDelegate?.loadViewController(storyBoard: "PrivateInvestigator", viewController: nil)
//            } else {
//                showAlert(title: "Error", message: "Please check your Registered Mobile Number and Password")
//            }
        }
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnSignIn.roundAllCorners(radius: 5.0)
        btnSignIn.addBorder(color: UIColor.black.cgColor, width: 1.0)
        txtEmailPhone.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtPassword.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtEmailPhone.delegate = self
        txtPassword.delegate = self
    }
    
    func login() {
        showActivityIndicator()
        APIManager.sharedInstance.postLogin(mobile: txtEmailPhone.text!, password: txtPassword.text!, onSuccess: { (userId, roleId, verified, msg) in
            self.hideActivityIndicator()
            if userId != "" {
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                UserDefaults.standard.set(userId, forKey: userIdUserDefaults)
                UserDefaults.standard.set(self.txtEmailPhone.text!, forKey: userMobileNumberUserDefaults)
                let userDetailsDictionary: [String:String] = ["FirstName": "", "LastName": "", "Gender": "", "DOB" : "", "GoogleID": "", "FacebookID": "", "Email": "", "Phone": self.txtEmailPhone.text!, "Countrycode" : "", "ProfilePicUrl" : "", "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "", "Longitude" : ""]
                UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
                if Int(roleId) == 1 {
                    UserDefaults.standard.set(1, forKey: userRoleIdUserDefaults)
                    if Int(verified) == 1 {
                        UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
                        UserDefaults.standard.set(completedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                        appDelegate?.loadViewController(storyBoard: "Booker", viewController: nil)
                    } else {
                        UserDefaults.standard.set(registeredSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                        appDelegate?.loadViewController(storyBoard: "Main", viewController: "GeneralSignUp")
                    }
                    
                } else if Int(roleId) == 2 {
                    UserDefaults.standard.set(2, forKey: userRoleIdUserDefaults)
                    if Int(verified) == 1 {
                        UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
                        UserDefaults.standard.set(completedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                        appDelegate?.loadViewController(storyBoard: "PrivateInvestigator", viewController: nil)
                    } else {
                        UserDefaults.standard.set(registeredSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                        appDelegate?.loadViewController(storyBoard: "Main", viewController: "GeneralSignUp")
                    }
                    
                }
                
            } else {
               self.showAlert(title: "Error", message: msg)
            }
        }, onFailure: { error in
            self.showAlert(title: "Error", message: "Something Went Wrong!!")
            self.hideActivityIndicator()
        })
    }

}

extension LoginVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtEmailPhone {
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
        } else {
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmailPhone {
            txtPassword.becomeFirstResponder()
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtPassword {
            if !StringManager.sharedInstance.validateMobile(text: txtEmailPhone.text!) {
                showAlert(title: "Error", message: "Please enter valid Mobile Number")
            } else if !StringManager.sharedInstance.validatePassword(text: txtPassword.text!) {
                showAlert(title: "Error", message: "Please enter valid Password")
            } else {
                login()
            }
        }
        return true
    }
}



