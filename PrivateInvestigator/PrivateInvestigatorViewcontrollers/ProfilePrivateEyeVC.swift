//
//  ProfilePrivateEyeVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/27/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import CoreLocation
import KSTokenView
import IQKeyboardManagerSwift

class ProfilePrivateEyeVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnMaleCheckbox: UIButton!
    @IBOutlet weak var btnFemaleCheckbox: UIButton!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtExtraAddress: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnEditAndDone: UIBarButtonItem!
    @IBOutlet weak var equipmentTags: KSTokenView!
    @IBOutlet weak var txtEmployer: UITextField!
    
    
    
    var userLat:Double?
    var userLng:Double?
    var addressChangedManually:Bool = false
    var selectedGender: Gender = .None
    var selectedTokensString:String = ""
    var isEditingEnabled: Bool = false
    let locationManager = CLLocationManager()
    let datePicker = UIDatePicker()
    let imagePicker: UIImagePickerController?=UIImagePickerController()
    var facebookId:String = ""
    var googleId:String = ""
    
    fileprivate var hashtagSearchMap: [String : Int64] = [:]
    fileprivate let tableCellFont = UIFont(name: "AvenirNext-Medium", size: 14)!
    private let textColor = UIColor.init(red: 106/255.0, green: 118/255.0, blue: 130/255.0, alpha: 1.0)
    var tokensEquipmentTags:[String] =  []//["hiddenCamera", "microphones" , "binoculars" , "trackingDevice", "Camera", "Drone", "Tools" , "mask"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        stopProfileEditing()
        setupEquipmentsTagsField()
        getUserProfileDetails()
        getTagsList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
    }
    

override func viewWillDisappear(_ animated: Bool) {
    IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
    IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
}
    
    
    @IBAction func clickBtnEditAndDone(_ sender: Any) {
        if isEditingEnabled {
            validateFieldsForUpdation()
        } else {
            setupProfileForEditing()
        }
        
    }
    
    @IBAction func clickBtnMaleCheckbox(_ sender: Any) {
        selectMaleOption()
    }
    
    @IBAction func clickBtnFemaleCheckbox(_ sender: Any) {
        selectFemaleOption()
    }
    
    @IBAction func clickTxtDob(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func clickBtnMap(_ sender: Any) {
        performSegue(withIdentifier: "toSelectLocationFromProfilePrivateEye", sender: self)
    }
    
    @IBAction func clickBtnCurrentLocation(_ sender: Any) {
        setupLocationManager()
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        imgProfilePic.roundAllCorners(radius: 50.0)
        imagePicker?.delegate = self
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.openCameraLibrary(sender:)))
        tapImage.delegate = self
        imgProfilePic.addGestureRecognizer(tapImage)
        btnCurrentLocation.roundAllCorners(radius: 5.0)
        btnMap.roundAllCorners(radius: 5.0)
        txtZipcode.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtEmployer.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        equipmentTags.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCity.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtStreet.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCountry.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtState.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtExtraAddress.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtZipcode.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCountry.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtState.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCity.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtStreet.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtExtraAddress.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtZipcode.delegate = self
        txtCountry.delegate = self
        txtState.delegate = self
        txtCity.delegate = self
        txtStreet.delegate = self
        txtExtraAddress.delegate = self
        txtDob.delegate = self
        txtEmployer.delegate = self
        txtFirstName.delegate = self
        txtLastName.delegate = self
    }
    
    func setupEquipmentsTagsField() {
        equipmentTags.delegate = self
        equipmentTags.promptText = ""
        equipmentTags.placeholder = "Enter Equipment Tags"
        equipmentTags.descriptionText = "Languages"
        equipmentTags.maxTokenLimit = 15 //default is -1 for unlimited number of tokens
        equipmentTags.style = .squared
        
        equipmentTags.font = UIFont(name: "AvenirNext-Medium", size: 13)!
        equipmentTags.promptText = ""
        equipmentTags.placeholderColor = textColor
        equipmentTags.descriptionText = ""
        equipmentTags.maxTokenLimit = 15
        equipmentTags.minimumCharactersToSearch = 1
        equipmentTags.activityIndicatorColor = UIColor.init(red: 25/255.0, green: 137/255.0, blue: 171/255.0, alpha: 1.0)
        equipmentTags.removesTokensOnEndEditing = false
        equipmentTags.searchResultBackgroundColor = textColor
        equipmentTags.tokenizingCharacters = [",", ".", " "]
        equipmentTags.direction = .vertical
        equipmentTags.delegate = self
        
    }
    
    func setupProfileForEditing() {
        self.navigationItem.rightBarButtonItem = nil
        isEditingEnabled = true
        let rightButtonItem = UIBarButtonItem.init(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(clickBtnEditAndDone(_:))
        )
        rightButtonItem.setTitleTextAttributes( [NSAttributedStringKey.font : UIFont(name: "AvenirNext-Regular", size: 17) ,NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        imgProfilePic.isUserInteractionEnabled = true
        txtFirstName.isUserInteractionEnabled = true
        txtLastName.isUserInteractionEnabled = true
        btnMaleCheckbox.isUserInteractionEnabled = true
        btnFemaleCheckbox.isUserInteractionEnabled = true
        txtDob.isUserInteractionEnabled = true
        txtZipcode.isUserInteractionEnabled = true
        txtCountry.isUserInteractionEnabled = true
        txtState.isUserInteractionEnabled = true
        txtCity.isUserInteractionEnabled = true
        txtStreet.isUserInteractionEnabled = true
        txtExtraAddress.isUserInteractionEnabled = true
        txtEmployer.isUserInteractionEnabled = true
        equipmentTags.isUserInteractionEnabled = true
        btnMap.isHidden = false
        btnCurrentLocation.isHidden = false
    }
    
    func stopProfileEditing() {
        self.navigationItem.rightBarButtonItem = nil
        isEditingEnabled = false
        let rightButtonItem = UIBarButtonItem.init(
            title: "",
            style: .done,
            target: self,
            action: #selector(clickBtnEditAndDone(_:))
        )
        rightButtonItem.image = UIImage(named: "editPencil")
        rightButtonItem.tintColor = UIColor.white
        rightButtonItem.setTitleTextAttributes( [NSAttributedStringKey.font : UIFont(name: "AvenirNext-Regular", size: 17) ,NSAttributedStringKey.foregroundColor : UIColor.white], for: .normal)
        self.navigationItem.rightBarButtonItem = rightButtonItem
        
        imgProfilePic.isUserInteractionEnabled = false
        txtFirstName.isUserInteractionEnabled = false
        txtLastName.isUserInteractionEnabled = false
        btnMaleCheckbox.isUserInteractionEnabled = false
        btnFemaleCheckbox.isUserInteractionEnabled = false
        txtDob.isUserInteractionEnabled = false
        txtZipcode.isUserInteractionEnabled = false
        txtCountry.isUserInteractionEnabled = false
        txtState.isUserInteractionEnabled = false
        txtCity.isUserInteractionEnabled = false
        txtStreet.isUserInteractionEnabled = false
        txtExtraAddress.isUserInteractionEnabled = false
        txtEmployer.isUserInteractionEnabled = false
        equipmentTags.isUserInteractionEnabled = false
        btnMap.isHidden = true
        btnCurrentLocation.isHidden = true
    }
    
    func getUserProfileDetails() {
        showActivityIndicator()
        APIManager.sharedInstance.postGetUserProfileDetails(onSuccess: { userProfile in
            self.hideActivityIndicator()
            UserDefaults.standard.set(userProfile, forKey: userProfileDetailsUserDefaults)
            self.updateProfileFromLocalData()
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Not able to get the profile details.")
        })
        
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
    
    
    func updateProfileFromLocalData() {
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
        txtDob.text = userDetails["DOB"] as? String ?? ""
        txtZipcode.text = userDetails["ZipCode"] as? String ?? ""
        txtCountry.text = userDetails["Country"] as? String ?? ""
        txtState.text = userDetails["State"] as? String ?? ""
        txtCity.text = userDetails["City"] as? String ?? ""
        txtStreet.text = userDetails["Street"] as? String ?? ""
        txtExtraAddress.text = userDetails["Address"] as? String ?? ""
        lblMobile.text = "\(userDetails["Countrycode"] as? String ?? "") \(userDetails["Phone"] as? String ?? "")"
        lblEmail.text = userDetails["Email"] as? String ?? ""
        txtEmployer.text = userDetails["CurrentEmployer"] as? String ?? ""
        let equipmentTagsString = userDetails["EquipmentTags"] as? String ?? ""
        facebookId = userDetails["FacebookID"] as? String ?? ""
        googleId = userDetails["GoogleID"] as? String ?? ""
        userLat = Double(userDetails["Latitude"] as? String ?? "0.0")
        userLng = Double(userDetails["Longitude"] as? String ?? "0.0")
        let equipmentTagsArray = equipmentTagsString.components(separatedBy: ",")
        for equipment in equipmentTagsArray {
            equipmentTags.addToken(KSToken(title: equipment))
        }
        
    }
    
    func validateFieldsForUpdation() {
        if !StringManager.sharedInstance.validateName(text: txtFirstName.text!) {
            showAlert(title: "Error", message: "Please enter valid First Name")
        } else if !StringManager.sharedInstance.validateName(text: txtLastName.text!) {
            showAlert(title: "Error", message: "Please enter valid Last Name")
        } else if selectedGender == .None {
            showAlert(title: "Error", message: "Please select Gender")
        } else if !StringManager.sharedInstance.validateName(text: txtDob.text!) {
            showAlert(title: "Error", message: "Please select Date of Birth")
        } else if !StringManager.sharedInstance.validateName(text: txtZipcode.text!) {
            showAlert(title: "Error", message: "Please enter zipcode")
        } else if !StringManager.sharedInstance.validateName(text: txtCountry.text!) {
            showAlert(title: "Error", message: "Please enter country")
        } else if !StringManager.sharedInstance.validateName(text: txtState.text!) {
            showAlert(title: "Error", message: "Please enter state")
        } else if !StringManager.sharedInstance.validateName(text: txtCity.text!) {
            showAlert(title: "Error", message: "Please enter city")
        } else {
            if let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as? Dictionary<String, Any> {
                var user = userDetails
                user["FirstName"] = txtFirstName.text!
                user["LastName"] = txtLastName.text!
                user["Gender"] = selectedGender.rawValue
                user["DOB"] = txtDob.text!
                user["Address"] = txtExtraAddress.text!
                user["Street"] = txtStreet.text!
                user["City"] = txtCity.text!
                user["State"] = txtState.text! 
                user["Country"] = txtCountry.text!
                user["ZipCode"] = txtZipcode.text!
                user["CurrentEmployer"] = txtEmployer.text!
                let tokens = equipmentTags.tokens()
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
                let address = "\(txtExtraAddress.text!) \(txtStreet.text!), \(txtCity.text!), \(txtState.text!), \(txtCountry.text!) \(txtZipcode.text!)"
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
    
    func updateUserDetails() {
        showActivityIndicator()
        let userId:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        APIManager.sharedInstance.putUpdateUserProfileDetails(userid: userId, firstname: txtFirstName.text!, lastname: txtLastName.text!, gender: selectedGender.rawValue, dob: txtDob.text!, address: txtExtraAddress.text!, street: txtStreet.text!, city: txtCity.text!, state: txtState.text!, country: txtCountry.text!, zipcode: txtZipcode.text!, userLat: userLat ?? 0.0, userLng: userLng ?? 0.0, currentEmp: txtEmployer.text!, equipmentTags: selectedTokensString, onSuccess: { status in
            self.hideActivityIndicator()
            if status {
                self.showAlert(title: "Success", message: "Profile successfully updated!!")
                self.stopProfileEditing()
            } else {
                self.showAlert(title: "Error", message: "Not able to update the profile.")
            }
        }, onFailure: { error  in
            self.hideActivityIndicator()
            self.showAlert(title: "Error", message: "Not able to update the profile.")
        })
        
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
    
    
    func fillAddressFieldsFromLocation(loc: CLLocationCoordinate2D) {
        let ceo: CLGeocoder = CLGeocoder()
        let location: CLLocation = CLLocation(latitude:loc.latitude, longitude: loc.longitude)
        ceo.reverseGeocodeLocation(location, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
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
                        self.txtZipcode.text = pm.postalCode!
                    }
                    self.addressChangedManually = false
                }
        })
    }
    
    
    func endLocationManager() {
        locationManager.stopUpdatingLocation()
    }
    
    func selectMaleOption() {
        selectedGender = .Male
        btnMaleCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        btnFemaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
    }
    
    func selectFemaleOption() {
        selectedGender = .Female
        btnMaleCheckbox.setImage(UIImage(named:"unchecked"), for: UIControlState.normal)
        btnFemaleCheckbox.setImage(UIImage(named:"checked"), for: UIControlState.normal)
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
        txtDob.inputAccessoryView = toolbar
        txtDob.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        txtDob.text = formatter.string(from: datePicker.date)
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
        imgProfilePic.contentMode = .scaleAspectFill
        imgProfilePic.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
  @objc  func textFieldDidChange(textField: UITextField) {
        addressChangedManually = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectLocationFromProfilePrivateEye" {
            let destVC:SelectLocationFromMapVC = segue.destination as! SelectLocationFromMapVC
            destVC.delegate = self
        }
    }
    
}


extension ProfilePrivateEyeVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 10
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 220
    }
}



extension ProfilePrivateEyeVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        userLat = locValue.latitude
        userLng = locValue.longitude
        fillAddressFieldsFromLocation(loc: locValue)
        endLocationManager()
    }
}

extension ProfilePrivateEyeVC : LocationSelectionDelegate {
    func locationSelected(selectedLocation: CLLocationCoordinate2D) {
        userLat = selectedLocation.latitude
        userLng = selectedLocation.longitude
        fillAddressFieldsFromLocation(loc: selectedLocation)
    }
}

extension ProfilePrivateEyeVC : KSTokenViewDelegate {
    func tokenView(_ tokenView: KSTokenView, performSearchWithString string: String, completion: ((Array<AnyObject>) -> Void)?) {
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
        cell?.textLabel?.text = "\(object)"//" (\(hashtagSearchMap[object as! String] ?? 0))"
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    
}


