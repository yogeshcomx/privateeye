//
//  NewBookerRegistrationVC.swift
//  PrivateInvestigator
//
//  Created by apple on 6/29/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import CoreLocation
import UIDropDown


class NewBookerRegistrationVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var imgProfilePic: UIImageView!
    @IBOutlet weak var btnMaleCheckbox: UIButton!
    @IBOutlet weak var btnFemaleCheckbox: UIButton!
    @IBOutlet weak var txtDob: UITextField!
    @IBOutlet weak var viewProfilePicAndName: UIView!
    @IBOutlet weak var viewGenderAndEmail: UIView!
    @IBOutlet weak var viewDOB: UIView!
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtExtraAddress: UITextField!
    @IBOutlet weak var btnCureentLocation: UIButton!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    
    
    var selectedGender: Gender = .None
    var userLat:Double?
    var userLng:Double?
    var addressChangedManually:Bool = false
    let locationManager = CLLocationManager()
    let datePicker = UIDatePicker()
    let imagePicker: UIImagePickerController?=UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
        loadProfileDetails()
    }

    @IBAction func clickBtnMaleCheckbox(_ sender: Any) {
        selectMaleOption()
    }
    
    @IBAction func clickBtnFemaleCheckbox(_ sender: Any) {
        selectFemaleOption()
    }
    
    @IBAction func clickTxtDOB(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func clickBtnGetCurrentLocation(_ sender: Any) {
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            showSettingsAlert(title: "Turn on Location", message: "Please go to Settings and turn on the location permissions and try again")
        }
        setupLocationManager()
    }
    @IBAction func clickBtnMap(_ sender: Any) {
        performSegue(withIdentifier: "toSelectLocationFromMapFromBookerRegistration", sender: self)
    }
    
    @IBAction func clickBtnDone(_ sender: Any) {
        if !StringManager.sharedInstance.validateName(text: txtFirstName.text!) {
            showAlert(title: "Error", message: "Please enter valid First Name")
        } else if !StringManager.sharedInstance.validateName(text: txtLastName.text!) {
            showAlert(title: "Error", message: "Please enter valid Last Name")
        } else if selectedGender == .None {
            showAlert(title: "Error", message: "Please select Gender")
        } else if !StringManager.sharedInstance.validateName(text: txtDob.text!) {
            showAlert(title: "Error", message: "Please select Date of Birth")
        } else if !StringManager.sharedInstance.validateName(text: txtPincode.text!) {
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
                user["ZipCode"] = txtPincode.text!
                user["CurrentEmployer"] = ""
                user["EquipmentTags"] = ""
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
        btnCureentLocation.roundAllCorners(radius: 5.0)
        btnMap.roundAllCorners(radius: 5.0)
        txtPincode.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCity.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtStreet.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCountry.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtState.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtExtraAddress.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        imagePicker?.delegate = self
        imgProfilePic.roundAllCorners(radius: imgProfilePic.frame.width/2)
        viewProfilePicAndName.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        viewGenderAndEmail.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        viewDOB.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(self.openCameraLibrary(sender:)))
        tapImage.delegate = self
        imgProfilePic.addGestureRecognizer(tapImage)
        
        txtPincode.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCountry.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtState.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCity.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtStreet.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtExtraAddress.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
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
                        self.txtPincode.text = pm.postalCode!
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
    
    

    func updateUserDetails() {
        showActivityIndicator()
        let userId:String = UserDefaults.standard.string(forKey: userIdUserDefaults) ?? ""
        APIManager.sharedInstance.putUpdateUserProfileDetails(userid: userId, firstname: txtFirstName.text!, lastname: txtLastName.text!, gender: selectedGender.rawValue, dob: txtDob.text!, address: txtExtraAddress.text!, street: txtStreet.text!, city: txtCity.text!, state: txtState.text!, country: txtCountry.text!, zipcode: txtPincode.text!, userLat: userLat ?? 0.0, userLng: userLng ?? 0.0, currentEmp: "", equipmentTags: "", onSuccess: { status in
            self.hideActivityIndicator()
            if status {
                UserDefaults.standard.set(completedSignUpFlowValue, forKey: registrationFlowStatusUserDefaults)
                let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.loadViewController(storyBoard: "Booker", viewController: nil)
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectLocationFromMapFromBookerRegistration" {
            let destVC:SelectLocationFromMapVC = segue.destination as! SelectLocationFromMapVC
            destVC.delegate = self
        }
    }
}

extension NewBookerRegistrationVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fillAddressFieldsFromLocation(loc: locValue)
        userLat = locValue.latitude
        userLng = locValue.longitude
        endLocationManager()
    }
}

extension NewBookerRegistrationVC : LocationSelectionDelegate {
    func locationSelected(selectedLocation: CLLocationCoordinate2D) {
        fillAddressFieldsFromLocation(loc: selectedLocation)
        userLat = selectedLocation.latitude
        userLng = selectedLocation.longitude
    }
}
