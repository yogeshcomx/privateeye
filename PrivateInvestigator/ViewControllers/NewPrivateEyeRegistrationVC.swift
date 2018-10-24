//
//  NewPrivateEyeRegistrationVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/20/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import UIDropDown
import KSTokenView
import CoreLocation
import IQKeyboardManagerSwift


class NewPrivateEyeRegistrationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {


    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var viewProfilePicAndName: UIView!
    @IBOutlet weak var viewGenderAndEmail: UIView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblMale: UILabel!
    @IBOutlet weak var lblFemale: UILabel!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var txtDOB: UITextField!
    @IBOutlet weak var txtCurrentEmployer: UITextField!
    @IBOutlet weak var dropDownPaymentMethod: UIDropDown!
    @IBOutlet weak var tagsEquipment: KSTokenView!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var txtExtraAddress: UITextField!
    
    var selectedGender: Gender = .None
    var selectedTokensString:String = ""
    var userLat:Double?
    var userLng:Double?
    var addressChangedManually:Bool = false
    let locationManager = CLLocationManager()
    let datePicker = UIDatePicker()
    let imagePicker: UIImagePickerController?=UIImagePickerController()
    
    fileprivate var hashtagSearchMap: [String : Int64] = [:]
    fileprivate let tableCellFont = UIFont(name: "AvenirNext-Medium", size: 14)!
    private let textColor = UIColor.init(red: 106/255.0, green: 118/255.0, blue: 130/255.0, alpha: 1.0)
    var tokensEquipmentTags:[String] =  []//["hiddenCamera", "microphones" , "binoculars" , "trackingDevice", "Camera", "Drone", "Tools" , "mask"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        setupPaymentDropdown()
        setupEquipmentsTagsField()
        loadProfileDetails()
        getTagsList()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @IBAction func clickBtnMale(_ sender: Any) {
        selectMaleOption()
    }
    
    @IBAction func clickBtnFemale(_ sender: Any) {
        selectFemaleOption()
    }
    
    
    @IBAction func clickTxtDob(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func clickBtnLocation(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            showSettingsAlert(title: "Turn on Location", message: "Please go to Settings and turn on the location permissions and try again")
        }
        setupLocationManager()
    }
    @IBAction func clickBtnMap(_ sender: Any) {
        performSegue(withIdentifier: "toSelectLocationFromMapFromPIRegistration", sender: self)
    }
    
    @IBAction func clickBtnNext(_ sender: Any) {
        if !StringManager.sharedInstance.validateName(text: txtFirstName.text!) {
            showAlert(title: "Error", message: "Please enter valid First Name")
        } else if !StringManager.sharedInstance.validateName(text: txtLastName.text!) {
            showAlert(title: "Error", message: "Please enter valid Last Name")
        } else if selectedGender == .None {
            showAlert(title: "Error", message: "Please select Gender")
        } else if !StringManager.sharedInstance.validateName(text: txtDOB.text!) {
            showAlert(title: "Error", message: "Please select Date of Birth")
        } else if !StringManager.sharedInstance.validateName(text: txtPincode.text!) {
            showAlert(title: "Error", message: "Please enter zipcode")
        } else if !StringManager.sharedInstance.validateName(text: txtCountry.text!) {
            showAlert(title: "Error", message: "Please enter country")
        } else if !StringManager.sharedInstance.validateName(text: txtState.text!) {
            showAlert(title: "Error", message: "Please enter state")
        } else if !StringManager.sharedInstance.validateName(text: txtCity.text!) {
            showAlert(title: "Error", message: "Please enter city")
        } else if !StringManager.sharedInstance.validateName(text: tagsEquipment.text) {
            showAlert(title: "Error", message: "Please tag your equipment")
        } else {
            if let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as? Dictionary<String, Any> {
                var user = userDetails
                user["FirstName"] = txtFirstName.text!
                user["LastName"] = txtLastName.text!
                user["Gender"] = selectedGender.rawValue
                user["DOB"] = txtDOB.text!
                user["Address"] = txtExtraAddress.text!
                user["Street"] = txtStreet.text!
                user["City"] = txtCity.text!
                user["State"] = txtState.text!
                user["Country"] = txtCountry.text!
                user["ZipCode"] = txtPincode.text!
                user["CurrentEmployer"] = txtCurrentEmployer.text!
                let tokens = tagsEquipment.tokens()
                selectedTokensString = ""
                for (index, value) in (tokens?.enumerated())! {
                    if index == 0 {
                        selectedTokensString = selectedTokensString + value.title
                    } else {
                        selectedTokensString = selectedTokensString + ",\(value.title)"
                    }
                }
                user["EquipmentTags"] = selectedTokensString
                user["Latitude"] = userLat ?? 0.0
                user["Longitude"] = userLng ?? 0.0
                UserDefaults.standard.set(user, forKey: userProfileDetailsUserDefaults)
            }
            if userLat == nil || userLng == nil || addressChangedManually == true {
                let geocoder = CLGeocoder()
                let address = "\(txtExtraAddress.text!) \(txtStreet.text!), \(txtCity.text!), \(txtState.text!), \(txtCountry.text!) \(txtPincode.text!)"
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        self.userLat = coordinates.latitude
                        self.userLng = coordinates.longitude
                    } else {
                        self.userLat = 0.0
                        self.userLng =  0.0
                    }
                    self.updateUserDetails()
                })
            } else {
                updateUserDetails()
            }
        }
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnCurrentLocation.roundAllCorners(radius: 5.0)
        btnMap.roundAllCorners(radius: 5.0)
        txtPincode.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCity.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtStreet.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCountry.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtState.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtExtraAddress.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        imagePicker?.delegate = self
        imgProfile.roundAllCorners(radius: imgProfile.frame.width/2)
        viewProfilePicAndName.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        viewGenderAndEmail.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        viewDOB.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCurrentEmployer.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.openCameraLibrary(sender:)))
        tapImage.delegate = self
        imgProfile.addGestureRecognizer(tapImage)
        
        txtPincode.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCountry.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtState.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCity.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtStreet.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtExtraAddress.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtPincode.delegate = self
        txtCountry.delegate = self
        txtState.delegate = self
        txtCity.delegate = self
        txtStreet.delegate = self
        txtExtraAddress.delegate = self
        txtDOB.delegate = self
        txtCurrentEmployer.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
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
    
    func setupPaymentDropdown() {
        dropDownPaymentMethod.extraWidth = 0.0
    }
    
    func loadProfileDetails() {
        let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as! Dictionary<String, Any>
        txtFirstName.text = userDetails["FirstName"] as? String ?? ""
        txtLastName.text = userDetails["LastName"] as? String ?? ""
        if let gender = userDetails["Gender"] as? String {
            if gender.lowercased() == "male" {
                selectMaleOption()
            } else if gender.lowercased() == "female" {
                selectFemaleOption()
            }
        }
    }
    
    
    func getTagsList() {
        let _ = showActivityIndicator()
        APIManager.sharedInstance.getTagsList(onSuccess: { tags in
            self.tokensEquipmentTags = tags
            self.hideActivityIndicator()
        }, onFailure: { error in
            print(error)
            self.hideActivityIndicator()
        })
    }
    
    
    func selectMaleOption() {
        selectedGender = .Male
        btnMale.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        btnFemale.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
    }
    
    func selectFemaleOption() {
        selectedGender = .Female
        btnMale.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnFemale.setImage(UIImage(named:"checked"), for: UIControlState.normal)
    }
    
    func setupEquipmentsTagsField() {
        tagsEquipment.delegate = self
        tagsEquipment.promptText = ""
        tagsEquipment.placeholder = "Enter Equipment Tags"
        tagsEquipment.descriptionText = "Languages"
        tagsEquipment.maxTokenLimit = 15 //default is -1 for unlimited number of tokens
        tagsEquipment.style = .squared
        
        tagsEquipment.font = UIFont(name: "AvenirNext-Medium", size: 13)!
        tagsEquipment.promptText = ""
        tagsEquipment.placeholderColor = textColor
        tagsEquipment.descriptionText = ""
        tagsEquipment.maxTokenLimit = 15
        tagsEquipment.minimumCharactersToSearch = 1
        tagsEquipment.activityIndicatorColor = UIColor.init(red: 25/255.0, green: 137/255.0, blue: 171/255.0, alpha: 1.0)
        tagsEquipment.removesTokensOnEndEditing = false
        tagsEquipment.searchResultBackgroundColor = textColor
        tagsEquipment.tokenizingCharacters = [",", ".", " "]
        tagsEquipment.direction = .vertical
        tagsEquipment.delegate = self
        
    }
    
    func showDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        txtDOB.inputAccessoryView = toolbar
        txtDOB.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDOB.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    @objc func openCameraLibrary(sender: UITapGestureRecognizer? = nil) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker!.allowsEditing = true
            imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var chosenImage: UIImage = UIImage()
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenImage = img
        } else if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            chosenImage = img
        }
        imgProfile.contentMode = .scaleAspectFill
        imgProfile.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func fillAddressFieldsFromLocation(loc: CLLocationCoordinate2D) {
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
                        if pm.subThoroughfare != nil {
                            addressString = addressString + pm.subThoroughfare! + ", "
                        }
                        if pm.thoroughfare != nil {
                            addressString = addressString + pm.thoroughfare!
                        }
                        if pm.subLocality != nil {
                            self.txtStreet.text =  pm.subLocality!
                        }
                        self.txtExtraAddress.text = addressString
                        if pm.locality != nil {
                            self.txtCity.text =  pm.locality!
                        }
                        if pm.country != nil {
                            self.txtCountry.text = pm.country!
                        }
                        if pm.administrativeArea != nil {
                            self.txtState.text = pm.administrativeArea!
                        }
                        if pm.postalCode != nil {
                            self.txtPincode.text = pm.postalCode!
                        }
                        self.addressChangedManually = false
                    }
                    
                }
                
                })
    }
    
    func updateUserDetails() {
        showActivityIndicator()
        let userId:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        APIManager.sharedInstance.putUpdateUserProfileDetails(userid: userId, firstname: txtFirstName.text!, lastname: txtLastName.text!, gender: selectedGender.rawValue, dob: txtDOB.text!, address: txtExtraAddress.text!, street: txtStreet.text!, city: txtCity.text!, state: txtState.text!, country: txtCountry.text!, zipcode: txtPincode.text!, userLat: userLat ?? 0.0, userLng: userLng ?? 0.0, currentEmp: txtCurrentEmployer.text!, equipmentTags: selectedTokensString, onSuccess: { status in
            self.hideActivityIndicator()
            if status {
                UserDefaults.standard.set(profileUpdatedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                self.performSegue(withIdentifier: "toPaymentPIRegistrationFromPIRegistration", sender: self)
              //  self.showPaymentScreen()
            } else {
                self.showAlert(title: "Error", message: "Not able to update the profile.")
            }
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Not able to update the profile.")
        })
        
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        addressChangedManually = true
    }
    
    
    func showPaymentScreen() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let payViewController = storyBoard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentVC
        payViewController.paymentPurpose = "Registration Fee"
        payViewController.paymentDescription = "This is the registration chrage for private eye to use the app."
        payViewController.currency = "AUD"
        payViewController.amount = 55.0
        payViewController.delegate = self
        self.present(payViewController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectLocationFromMapFromPIRegistration" {
            let destVC:SelectLocationFromMapVC = segue.destination as! SelectLocationFromMapVC
            destVC.delegate = self
        }
    }

}

extension NewPrivateEyeRegistrationVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
        if textField == txtPincode {
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
        } else {
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
        if textField == txtPincode {
            txtCountry.becomeFirstResponder()
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtCountry {
            txtState.becomeFirstResponder()
        } else if textField == txtState {
            txtCity.becomeFirstResponder()
        } else if textField == txtCity {
            txtStreet.becomeFirstResponder()
        } else if textField == txtStreet {
            txtExtraAddress.becomeFirstResponder()
        } else if textField == txtExtraAddress {
           txtCurrentEmployer.becomeFirstResponder()
        }
        return true
    }
}

extension NewPrivateEyeRegistrationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fillAddressFieldsFromLocation(loc: locValue)
        userLat = locValue.latitude
        userLng = locValue.longitude
        endLocationManager()
    }
}

extension NewPrivateEyeRegistrationVC : LocationSelectionDelegate {
    func locationSelected(selectedLocation: CLLocationCoordinate2D) {
        fillAddressFieldsFromLocation(loc: selectedLocation)
        userLat = selectedLocation.latitude
        userLng = selectedLocation.longitude
    }
}

extension NewPrivateEyeRegistrationVC : KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((Array<AnyObject>) -> Void)?) {
        dropDownPaymentMethod.isHidden = true
        if (string.isEmpty){
            completion!(tokensEquipmentTags as Array<AnyObject>)
            return
        }
        let filtered = tokensEquipmentTags.filter { $0.localizedCaseInsensitiveContains(string) }
        if filtered.count == 0 {
            completion!(tokensEquipmentTags as Array<AnyObject>)
            return
        }
        completion!(filtered as Array<AnyObject>)
    }
    
    func tokenViewDidEndEditing(_ tokenView: KSTokenView) {
        dropDownPaymentMethod.isHidden = false
    }
    
    func tokenView(_ tokenView: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return "\(object)"
    }
    
    func tokenView(_ tokenView: KSTokenView, willAddToken token: KSToken) {
        token.title = "\(token.title.replacingOccurrences(of: "#", with: ""))".uppercased()
        
        token.tokenBackgroundColor = UIColor.init(red: 0/255.0, green: 132/255.0, blue: 233/255.0, alpha: 1.0)
    }
    
    func tokenView(_ tokenView: KSTokenView, withObject object: AnyObject, tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "KSSearchTableCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.textLabel?.font = tableCellFont
        cell?.textLabel?.textColor = UIColor.white
        cell?.backgroundColor = tokenView.searchResultBackgroundColor
        cell?.textLabel?.text = "\(object)" //" (\(hashtagSearchMap[object as! String] ?? 0))"
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}


extension NewPrivateEyeRegistrationVC : paymentDelegate {
    func paymentSuccess(transactionId: String) {
        showAlert(title: "Payment Success", message: transactionId)
    }
}
