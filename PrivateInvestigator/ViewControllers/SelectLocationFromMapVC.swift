//
//  SelectLocationFromMapVC.swift
//  PrivateInvestigator
//
//  Created by apple on 7/11/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

protocol LocationSelectionDelegate: class {
    func locationSelected(selectedLocation: CLLocationCoordinate2D  )
}


class SelectLocationFromMapVC: UIViewController {
    
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imgCenterMarker: UIImageView!
    
    var delegate:LocationSelectionDelegate?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
    }


    @IBAction func clickBtnDone(_ sender: Any) {
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let centerMapCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        delegate?.locationSelected(selectedLocation: centerMapCoordinate)
        navigationController?.popViewController(animated: true)
    }
    
    func setupUI() {
        setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        mapView.addSubview(imgCenterMarker)
        mapView.bringSubview(toFront: imgCenterMarker)
        
    }
    
    func setupMap(lat:CLLocationDegrees, lng:CLLocationDegrees) {
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.padding = mapInsets
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        
    }
    
    
    func setupLocationManager() {
        if CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .restricted {
            showSettingsAlert(title: "Turn on Location", message: "Please go to Settings and turn on the location permissions")
        }
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
    
    
}

extension SelectLocationFromMapVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        setupMap(lat: locValue.latitude, lng: locValue.longitude)
        endLocationManager()
    }
}
