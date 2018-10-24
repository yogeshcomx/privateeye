//
//  RegisterAndPhoneVerificationVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/28/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import UIDropDown
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAuth
import CoreLocation
import IQKeyboardManagerSwift

class RegisterAndPhoneVerificationVC: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var dropDownCountryCode: UIDropDown!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var viewOTP: UIView!
    @IBOutlet weak var txtOtp: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var viewFacebookLogin: UIView!
    @IBOutlet weak var btnResend: UIButton!
    
    //Variable Declarations
    var userRoleID:Int = 0
    var selectedCountry:Country?
    var facebookId:String = ""
    var googleId:String = ""
    var forRegister:Bool = false
    
    let locationManager = CLLocationManager()
    
    //Array Variable Declarations
    var countryCodeList:[Country] = [] 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFBLoginButton()
        GIDSignIn.sharedInstance().uiDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.googleSignInResponse), name: NSNotification.Name(rawValue: googleSignInNotification), object: nil)
        //getContriesDataFromFile()
        getCountriesDataFromServer()
        loadPhoneVerificationView()
        setupLocationManager()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    
    
    @IBAction func clickBtnRegister(_ sender: Any) {
        if let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as? Dictionary<String, Any> {
            var user = userDetails
            user["Phone"] = txtMobile.text!
            user["Countrycode"] = selectedCountry?.country_code ?? ""
            UserDefaults.standard.set(user, forKey: userProfileDetailsUserDefaults)
        } else {
            let userDetailsDictionary: [String:String] = ["FirstName": "", "LastName": "", "Gender": "", "DOB" : "", "GoogleID": "", "FacebookID": "", "Email": txtEmail.text!, "Phone": txtMobile.text!, "Countrycode" : selectedCountry?.country_code ?? "", "ProfilePicUrl" : "", "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "", "Longitude" : ""]
            UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
        }
        register()
    }
    
    
    
    @IBAction func clickBtnSubmit(_ sender: Any) {
        /*
         showActivityIndicator()
         let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as! Dictionary<String, Any>
         let mobileNo = userDetails["Phone"] as? String ?? ""
         APIManager.sharedInstance.getPhoneNumberVerification(mobile: mobileNo, otp: txtOtp.text!, onSuccess: { (status, msg) in
         self.hideActivityIndicator()
         if status {
         UserDefaults.standard.set(phoneNumberVerifiedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
         if self.userRoleID == 1 {
         UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
         UserDefaults.standard.set(1, forKey: userRoleIdUserDefaults)
         self.performSegue(withIdentifier: "toBookerRegistrationFromSignUp", sender: self)
         } else if self.userRoleID == 2 {
         UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
         UserDefaults.standard.set(2, forKey: userRoleIdUserDefaults)
         self.performSegue(withIdentifier: "toPrivateInvestigatorRegistrationFromSignUp", sender: self)
         }
         } else {
         self.showAlert(title: "Error", message: msg)
         }
         }, onFailure: {_ in
         self.hideActivityIndicator()
         self.showAlert(title: "Error", message: "Something Went Wrong.\nRegistration Failed")
         })
         */
        
        verifyPhoneNumberOTPFromFirebase()
        
    }
    
    
    
    @IBAction func clickBtnResend(_ sender: Any) {
        if let mobile = UserDefaults.standard.string(forKey: userMobileNumberUserDefaults) {
            //resendOTP(mobile: mobile)
            let phoneNum:String = "+\(selectedCountry?.country_code ?? "")\(mobile)"
            sendOTPFromFirebase(phoneNumber: phoneNum)
        }
    }
    
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        txtEmail.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtMobile.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtPassword.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtOtp.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        viewOTP.roundAllCorners(radius: 5.0)
        viewOTP.addBorder(color: UIColor.black.cgColor, width: 1.0)
        btnRegister.roundAllCorners(radius: 5.0)
        btnRegister.addBorder(color: UIColor.black.cgColor, width: 1.0)
        btnSubmit.roundAllCorners(radius: 5.0)
        btnSubmit.addBorder(color: UIColor.black.cgColor, width: 1.0)
        btnResend.roundAllCorners(radius: 5.0)
        btnResend.addBorder(color: UIColor.black.cgColor, width: 1.0)
        viewOTP.isHidden = true
        txtEmail.delegate = self
        txtMobile.delegate = self
        txtPassword.delegate = self
        txtOtp.delegate = self
        if self.userRoleID == 0 {
            let roleid = UserDefaults.standard.integer(forKey: userRoleIdUserDefaults) ?? 0
            self.userRoleID = roleid
        }
    }
    
    
    
    func setupFBLoginButton() {
        let loginButton = FBSDKLoginButton(frame: CGRect(x: 0.0, y: 0.0, width: 190, height: 30))
        loginButton.readPermissions = ["public_profile", "email"]
        loginButton.delegate = self
        viewFacebookLogin.addSubview(loginButton)
    }
    
    
    
    func setUpContryDropDown() {
        dropDownCountryCode.borderWidth = 1.0
        dropDownCountryCode.tableHeight = 150.0
        dropDownCountryCode.tableWillAppear {
            self.view.bringSubview(toFront: self.dropDownCountryCode)
        }
        let countryCodeNames = countryCodeList.map{"\($0.country_name)  \($0.country_code)"}
        dropDownCountryCode.textAlignment = .center
        dropDownCountryCode.textColor = UIColor.black
        dropDownCountryCode.placeholder = ""
        dropDownCountryCode.layer.zPosition = 10
        dropDownCountryCode.options = countryCodeNames
        dropDownCountryCode.didSelect { (option, index) in
            self.selectedCountry = self.countryCodeList[index]
            self.dropDownCountryCode.title.text = self.countryCodeList[index].country_code
            self.dropDownCountryCode.resign()
        }
        self.view.addSubview(dropDownCountryCode)
    }
    
    
    
    func loadPhoneVerificationView() {
        if !forRegister {
            let userId = UserDefaults.standard.string(forKey: userIdUserDefaults)
            let roleId = UserDefaults.standard.string(forKey: userRoleIdUserDefaults)
            let registerFlow = UserDefaults.standard.string(forKey: registrationFlowStatusUserDefaults)
            if let mobile = UserDefaults.standard.string(forKey: userMobileNumberUserDefaults) {
                resendOTP(mobile: mobile)
               // self.showAlert(title: "Alert", message: "Your Account is not verified.\nEnter the OTP sent to registered Mobile Number")
                let alertController = UIAlertController(title:"Alert",message:"Your Account is not verified.\nEnter the One Time Password sent to registered Mobile Number",preferredStyle:.alert)
                self.present(alertController,animated:true,completion:{Timer.scheduledTimer(withTimeInterval: 4, repeats:false, block: {_ in
                    self.dismiss(animated: true, completion: nil)
                    self.sendOTPFromFirebase(phoneNumber: mobile)
                    self.btnRegister.isHidden = true
                    self.viewOTP.isHidden = false
                })})
               // resendOTP(mobile: mobile)
                
            }
        }
    }
    
    
    
    func getContriesDataFromFile() {
        if let path = Bundle.main.path(forResource: "countriesCode", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                countryCodeList.removeAll()
                countryCodeList = JsonDataManager.sharedInstance.parseCountryDataFromFile(JSONData: data)
                setUpContryDropDown()
            } catch {
            }
        }
    }
    
    
    
    func getCountriesDataFromServer() {
        if countriesListGlobal.count > 0 {
            self.countryCodeList = countriesListGlobal
            self.setUpContryDropDown()
            if selectedCountry == nil {
                setupLocationManager()
            }
        } else {
            showActivityIndicator()
            APIManager.sharedInstance.getCountryCodeList(onSuccess: { countries in
                self.countryCodeList = countries
                self.setUpContryDropDown()
                self.hideActivityIndicator()
                if self.selectedCountry == nil {
                    self.setupLocationManager()
                }
                
            }, onFailure: { error in
                print(error)
                self.hideActivityIndicator()
            })
        }
        
    }
    
    
    
    func register() {
        if !StringManager.sharedInstance.validateEmail(text: txtEmail.text!) {
            showAlert(title: "Error", message: "Please enter valid Email Id")
        } else if selectedCountry == nil {
            showAlert(title: "Error", message: "Please select country code")
        } else if !StringManager.sharedInstance.validateMobile(text: txtMobile.text!) {
            showAlert(title: "Error", message: "Please enter valid Mobile Number")
        } else if !StringManager.sharedInstance.validatePassword(text: txtPassword.text!) {
            showAlert(title: "Error", message: "Please enter valid Password")
        } else {
            showActivityIndicator()
            APIManager.sharedInstance.postRegister(email: txtEmail.text!, countryCode: (selectedCountry?.country_code)!, mobile: txtMobile.text!, userRole: String(userRoleID), password: txtPassword.text!, facebookId: facebookId, googleId: googleId, onSuccess: { (userId, message) in
                self.hideActivityIndicator()
                if userId != "" {
                    print("user Registered!! USER ID: \(userId)")
                   // self.showAlert(title: "Success", message: "Registration Completed Successfully!!\n One Time Password is sent to registered Mobile Number")
                    UserDefaults.standard.set(userId, forKey: userIdUserDefaults)
                    UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
                    UserDefaults.standard.set(self.userRoleID, forKey: userRoleIdUserDefaults)
                    UserDefaults.standard.set(self.txtMobile.text!, forKey: userMobileNumberUserDefaults)
                    UserDefaults.standard.set(registeredSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                    self.btnRegister.isHidden = true
                    self.viewOTP.isHidden = false
                    let phoneNum:String = "+\(self.selectedCountry?.country_code ?? "")\(self.txtMobile.text!)"
                    self.sendOTPFromFirebase(phoneNumber: phoneNum)
                } else {
                    self.showAlert(title: "Error", message: message)
                }
            }, onFailure: { error in
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: "Something Went Wrong.\nRegistration Failed")
            })
        }
        
    }
    
    
    
    func sendOTPFromFirebase(phoneNumber:String) {
        showActivityIndicator()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            self.hideActivityIndicator()
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            UserDefaults.standard.set(verificationID, forKey: firebaseAuthVerificationID)
        }
    }
    
    
    
    func verifyPhoneNumberOTPFromFirebase() {
        showActivityIndicator()
        let verificationID = UserDefaults.standard.string(forKey: firebaseAuthVerificationID)
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID ?? "",
            verificationCode: txtOtp.text!)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: error.localizedDescription)
                return
            }
            let userid = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
            APIManager.sharedInstance.putUpdateUserPhoneNumberVerificationStatus(userid: userid, verifiedPhone: "1", onSuccess: { status in
                self.hideActivityIndicator()
                if status {
                    UserDefaults.standard.set(phoneNumberVerifiedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                    if self.userRoleID == 1 {
                        UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
                        UserDefaults.standard.set(1, forKey: userRoleIdUserDefaults)
                        self.performSegue(withIdentifier: "toBookerRegistrationFromSignUp", sender: self)
                    } else if self.userRoleID == 2 {
                        UserDefaults.standard.set(true, forKey: userLoginStatusUserDefaults)
                        UserDefaults.standard.set(2, forKey: userRoleIdUserDefaults)
                        self.performSegue(withIdentifier: "toPrivateInvestigatorRegistrationFromSignUp", sender: self)
                    }
                } else {
                    self.showAlert(title: "Error", message: "Something Went Wrong.\nPlease verify your phone number using Resend option")
                }
                
            }, onFailure: { error  in
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: "Something Went Wrong.\nPlease verify your phone number using Resend option")
            })
        }
    }
    
    
    
    func resendOTP(mobile:String) {
        showActivityIndicator()
        APIManager.sharedInstance.putResendOTPmobile(mobile: mobile, onSuccess: { status in
            self.hideActivityIndicator()
            if status {
            } else {
                self.showAlert(title: "Error", message: "Something Went Wrong.\nNot able to send One Time Password to your mobile number")
            }
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Something Went Wrong.\nNot able to send One Time Password to your mobile number")
        })
    }
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let _ = FBSDKAccessToken.current() {
            fetchFBUserProfile()
        }
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged Out")
    }
    
    
    
    func fetchFBUserProfile() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id, email, name, first_name,last_name, picture.width(480).height(480)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("Error took place: \(error)")
            }
            else
            {
                if let result = result as? [String: Any] {
                    guard let email = result["email"] as? String else {
                        return
                    }
                    guard let username = result["name"] as? String else {
                        return
                    }
                    guard let firstname = result["first_name"] as? String else {
                        return
                    }
                    guard let lastname = result["last_name"] as? String else {
                        return
                    }
                    guard let userId = result["id"] as? String else {
                        return
                    }
                    let userDetailsDictionary: [String:String] = ["FirstName": firstname, "LastName": lastname, "Gender": "", "DOB" : "", "GoogleID": "", "FacebookID": userId, "Email": email, "Phone": "", "Countrycode" : "", "ProfilePicUrl" : "", "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "", "Longitude" : ""]
                    UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
                    self.facebookId = userId
                    self.txtEmail.text = email
                    self.txtMobile.text = ""
                }
            }
        })
    }
    
    
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
    }
    
    
    
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        showActivityIndicator()
        self.present(viewController, animated: true, completion: nil)
    }
    
    
    
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @objc func googleSignInResponse(notification: NSNotification){
        hideActivityIndicator()
        if let result = notification.userInfo?["result"] as? Bool {
            if result == true {
                let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as! Dictionary<String, Any>
                googleId = userDetails["GoogleID"] as? String ?? ""
                txtEmail.text = userDetails["Email"] as? String ?? ""
                txtMobile.text = userDetails["Phone"] as? String ?? ""
            } else {
                
            }
        }
    }
    
    
    
    func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func endLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    func fillAddressFieldsFromLocation(loc: CLLocationCoordinate2D, forCountry: Bool) {
        let ceo: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude:loc.latitude, longitude: loc.longitude)
        ceo.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                if let pm = placemarks as? [CLPlacemark] {
                    if pm.count > 0 {
                        let pm = placemarks![0]
                        var addressString : String = ""
                        if forCountry {
                            if pm.country != nil {
                                let filteredCountry = self.countryCodeList.filter{$0.country_name == pm.country!}
                                if filteredCountry.count > 0 {
                                    self.selectedCountry = filteredCountry[0]
                                    self.dropDownCountryCode.title.text = self.selectedCountry?.country_code
                                }
                            }
                            return
                        }
                    }
                    
                }
                
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}


extension RegisterAndPhoneVerificationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fillAddressFieldsFromLocation(loc: locValue, forCountry: true)
        endLocationManager()
    }
}

extension RegisterAndPhoneVerificationVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtMobile {
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
        } else {
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtMobile {
            txtPassword.becomeFirstResponder()
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtEmail {
            txtMobile.becomeFirstResponder()
        } else if textField == txtMobile {
            txtPassword.becomeFirstResponder()
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        } else if textField == txtPassword {
            if let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as? Dictionary<String, Any> {
                var user = userDetails
                user["Phone"] = txtMobile.text!
                user["Countrycode"] = selectedCountry?.country_code ?? ""
                UserDefaults.standard.set(user, forKey: userProfileDetailsUserDefaults)
            } else {
                let userDetailsDictionary: [String:String] = ["FirstName": "", "LastName": "", "Gender": "", "DOB" : "", "GoogleID": "", "FacebookID": "", "Email": txtEmail.text!, "Phone": txtMobile.text!, "Countrycode" : selectedCountry?.country_code ?? "", "ProfilePicUrl" : "", "Address": "", "Street" : "", "City": "", "State": "", "Country" : "", "ZipCode" : "", "CurrentEmployer" : "", "EquipmentTags" : "", "Latitude" : "", "Longitude" : ""]
                UserDefaults.standard.set(userDetailsDictionary, forKey: userProfileDetailsUserDefaults)
            }
            register()
        } else if textField == txtOtp {
            verifyPhoneNumberOTPFromFirebase()
        }
        return true
    }
}
