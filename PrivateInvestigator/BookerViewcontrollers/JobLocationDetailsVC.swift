//
//  JobLocationDetailsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/16/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import IQKeyboardManagerSwift

protocol LocationDetailsSelectionDelegate: class {
    func LocationDetailsSelected(locName:String, locExtraAddress:String, locStreet: String, locCity:String, locState:String, locCountry:String, locZipcode:String, locLat:Double, locLng:Double)
}

class JobLocationDetailsVC: UIViewController {

    
    
    @IBOutlet weak var txtLocationName: UITextField!
    @IBOutlet weak var txtZipcode: UITextField!
    @IBOutlet weak var txtCountry: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtStreet: UITextField!
    @IBOutlet weak var txtExtraAddress: UITextField!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    
    var locationName:String?
    var extraAddress:String?
    var street:String?
    var city:String?
    var state:String?
    var country:String?
    var zipcode:String?
    var lat:Double?
    var lng:Double?
    var addressChangedManually:Bool = false
    var delegate:LocationDetailsSelectionDelegate?
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
        setupLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }

    @IBAction func clickBtnMap(_ sender: Any) {
         self.view.endEditing(true)
        performSegue(withIdentifier: "toSelectLocationFromMapFromJobLocation", sender: self)
    }
    
    @IBAction func clickBtnCurrentLocation(_ sender: Any) {
         self.view.endEditing(true)
//        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
//            showSettingsAlert(title: "Turn on Location", message: "Please go to Settings and turn on the location permissions and try again")
//        }
//        setupLocationManager()
        
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        self.present(acController, animated: true, completion: nil)
    }
    
    @IBAction func clickBtnDone(_ sender: Any) {
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        saveLocationData()
    }
    
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnCurrentLocation.roundAllCorners(radius: 5.0)
        btnMap.roundAllCorners(radius: 5.0)
        txtLocationName.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtZipcode.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCity.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtStreet.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtCountry.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtState.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        txtExtraAddress.layer.addBorder(edge: .bottom, color: UIColor.black, thickness: 1.0)
        
        txtLocationName.delegate = self
        txtExtraAddress.delegate = self
        txtStreet.delegate = self
        txtCity.delegate = self
        txtState.delegate = self
        txtCountry.delegate = self
        txtZipcode.delegate = self
        txtZipcode.addDoneOnKeyboardWithTarget(self, action: #selector(saveLocationData))
        
        txtZipcode.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCountry.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtState.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtCity.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtStreet.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        txtExtraAddress.addTarget(self, action:#selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
    }
    
    func loadData() {
        locationName = NewCaseVC.caseGlobal.locationName
        locationName = NewCaseVC.caseGlobal.locationName
        extraAddress = NewCaseVC.caseGlobal.extraAddress
        street = NewCaseVC.caseGlobal.street
        city = NewCaseVC.caseGlobal.city
        state = NewCaseVC.caseGlobal.state
        country = NewCaseVC.caseGlobal.country
        zipcode = NewCaseVC.caseGlobal.zipcode
        lat = NewCaseVC.caseGlobal.caseLat
        lng = NewCaseVC.caseGlobal.caseLng
        
        
        txtLocationName.text = locationName ?? ""
        txtExtraAddress.text = extraAddress ?? ""
        txtStreet.text = street ?? ""
        txtCity.text = city ?? ""
        txtState.text = state ?? ""
        txtCountry.text = country ?? ""
        txtZipcode.text = zipcode ?? ""
//        let userDetails:Dictionary<String,Any> = UserDefaults.standard.value(forKey: userProfileDetailsUserDefaults) as! Dictionary<String, Any>
//        if country == nil {
//            txtCountry.text = userDetails["Country"] as? String ?? ""
//        } else {
//           txtCountry.text = country ?? ""
//        }
//        if zipcode == nil {
//            txtZipcode.text = userDetails["ZipCode"] as? String ?? ""
//        } else {
//            txtZipcode.text = zipcode ?? ""
//        }
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
                                self.txtCountry.text = pm.country!
                            }
                            return
                        }
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
                    
                }
                
        })
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        addressChangedManually = true
    }
    
  @objc  func saveLocationData() {
        self.view.endEditing(true) 
        if txtLocationName.text == "" {
            showAlert(title: "Error", message: "Please enter location name")
        } else if txtZipcode.text == "" {
            showAlert(title: "Error", message: "Please enter zipcode")
        } else if txtCountry.text == "" {
            showAlert(title: "Error", message: "Please enter country")
        } else if txtState.text == "" {
            showAlert(title: "Error", message: "Please enter state")
        } else if txtCity.text == "" {
            showAlert(title: "Error", message: "Please enter city")
        } else if txtExtraAddress.text == "" {
            showAlert(title: "Error", message: "Please enter street")
        } else {
            if lat == nil || lng == nil || addressChangedManually == true {
                let geocoder = CLGeocoder()
                let address = "\(txtExtraAddress.text!) \(txtStreet.text!), \(txtCity.text!), \(txtState.text!), \(txtCountry.text!) \(txtZipcode.text!)"
                geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("Error", error ?? "")
                    }
                    if let placemark = placemarks?.first {
                        let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                        self.lat = coordinates.latitude
                        self.lng = coordinates.longitude
                    } else {
                        self.lat = 0.0
                        self.lng =  0.0
                    }
                    self.delegate?.LocationDetailsSelected(locName: self.txtLocationName.text!, locExtraAddress: self.txtExtraAddress.text!, locStreet: self.txtStreet.text!, locCity: self.txtCity.text!, locState: self.txtState.text!, locCountry: self.txtCountry.text!, locZipcode: self.txtZipcode.text!, locLat: self.lat ?? 0.0, locLng: self.lng ?? 0.0)
                    //self.navigationController?.popViewController(animated: true)
                    NewCaseVC.caseGlobal.locationName = self.txtLocationName.text!
                    NewCaseVC.caseGlobal.extraAddress = self.txtExtraAddress.text!
                    NewCaseVC.caseGlobal.street = self.txtStreet.text!
                    NewCaseVC.caseGlobal.city = self.txtCity.text!
                    NewCaseVC.caseGlobal.state = self.txtState.text!
                    NewCaseVC.caseGlobal.country = self.txtCountry.text!
                    NewCaseVC.caseGlobal.zipcode = self.txtZipcode.text!
                    NewCaseVC.caseGlobal.caseLat = self.lat ?? 0.0
                    NewCaseVC.caseGlobal.caseLng = self.lng ?? 0.0
                    self.performSegue(withIdentifier: "toCaseDateOutcomeDescriptionDetailsFromJobLocationDetails", sender: self)
                })
            } else {
                delegate?.LocationDetailsSelected(locName: txtLocationName.text!, locExtraAddress: txtExtraAddress.text!, locStreet: txtStreet.text!, locCity: txtCity.text!, locState: txtState.text!, locCountry: txtCountry.text!, locZipcode: txtZipcode.text!, locLat: lat ?? 0.0, locLng: lng ?? 0.0)
                //navigationController?.popViewController(animated: true)
                NewCaseVC.caseGlobal.locationName = self.txtLocationName.text!
                NewCaseVC.caseGlobal.extraAddress = self.txtExtraAddress.text!
                NewCaseVC.caseGlobal.street = self.txtStreet.text!
                NewCaseVC.caseGlobal.city = self.txtCity.text!
                NewCaseVC.caseGlobal.state = self.txtState.text!
                NewCaseVC.caseGlobal.country = self.txtCountry.text!
                NewCaseVC.caseGlobal.zipcode = self.txtZipcode.text!
                NewCaseVC.caseGlobal.caseLat = self.lat ?? 0.0
                NewCaseVC.caseGlobal.caseLng = self.lng ?? 0.0
                performSegue(withIdentifier: "toCaseDateOutcomeDescriptionDetailsFromJobLocationDetails", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectLocationFromMapFromJobLocation" {
            let destVC:SelectLocationFromMapVC = segue.destination as! SelectLocationFromMapVC
            destVC.delegate = self
        }
    }
}


extension JobLocationDetailsVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        fillAddressFieldsFromLocation(loc: locValue, forCountry: true)
        lat = locValue.latitude
        lng = locValue.longitude
        endLocationManager()
    }
}

extension JobLocationDetailsVC : LocationSelectionDelegate {
    func locationSelected(selectedLocation: CLLocationCoordinate2D) {
        fillAddressFieldsFromLocation(loc: selectedLocation, forCountry: false)
        lat = selectedLocation.latitude
        lng = selectedLocation.longitude
    }
}

extension JobLocationDetailsVC : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtZipcode {
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
        } else {
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
        }
//        if textField == txtLocationName {
//        let acController = GMSAutocompleteViewController()
//        acController.delegate = self
//        self.present(acController, animated: true, completion: nil)
//        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == txtLocationName {
            txtExtraAddress.becomeFirstResponder()
        } else if textField == txtExtraAddress {
            txtStreet.becomeFirstResponder()
        } else if textField == txtStreet {
            txtCity.becomeFirstResponder()
        } else if textField == txtCity {
            txtState.becomeFirstResponder()
        } else if textField == txtState {
            txtCountry.becomeFirstResponder()
        } else if textField == txtCountry {
            txtZipcode.becomeFirstResponder()
            IQKeyboardManager.sharedManager().enableAutoToolbar = true
        } else if textField == txtZipcode {
            IQKeyboardManager.sharedManager().enableAutoToolbar = false
            saveLocationData()
        }
        return true
    }
}

extension JobLocationDetailsVC: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "null")")
        self.txtLocationName.text = place.name
        fillAddressFieldsFromLocation(loc: place.coordinate, forCountry: false)
        lat = place.coordinate.latitude
        lng = place.coordinate.longitude
        
        print("Place attributions: \(String(describing: place.attributions))")
        
        self.dismiss(animated: true, completion: nil)
    }
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        //        print("Error: \(error.description)")
        self.dismiss(animated: true, completion: nil)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        print("Autocomplete was cancelled.")
        self.dismiss(animated: true, completion: nil)
    }
}

