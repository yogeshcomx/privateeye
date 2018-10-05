//
//  CaseLocationMapWithDirectionsVC.swift
//  PrivateInvestigator
//
//  Created by apple on 9/24/18.
//  Copyright © 2018 Comx. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

class CaseLocationMapWithDirectionsVC: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnNavigation: UIButton!
    @IBOutlet weak var btnDirection: UIButton!
    
    var caselat:Double?
    var caselng:Double?
    var currentLat:Double?
    var currentLng:Double?
    var delegate:LocationSelectionDelegate?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        setupUI()
        setupLocationManager()
    }

    @IBAction func clickBtnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func clickBtnNavigation(_ sender: Any) {
        let caseLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(caselat ?? 0.0, caselng ?? 0.0)
        if let UrlNavigation = URL.init(string: "comgooglemaps://") {
            if UIApplication.shared.canOpenURL(UrlNavigation){
                if caseLoc.longitude != nil && caseLoc.latitude != nil {
                    
                    let lat =  caseLoc.latitude ?? 0.0
                    let longi = caseLoc.longitude ?? 0.0
                    
                    if let urlDestination = URL.init(string: "comgooglemaps://?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                        UIApplication.shared.openURL(urlDestination)
                    }
                }
            }
            else {
                NSLog("Can't use comgooglemaps://");
                self.openTrackerInBrowser(destinationLoc: caseLoc)
                
            }
        }
        else
        {
            NSLog("Can't use comgooglemaps://");
            self.openTrackerInBrowser(destinationLoc: caseLoc)
        }
    }
    
    
    
    @IBAction func clickBtnDirection(_ sender: Any) {
        let currentLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(currentLat ?? 0.0,currentLng ?? 0.0)
        let caseLoc:CLLocationCoordinate2D = CLLocationCoordinate2DMake(caselat ?? 0.0, caselng ?? 0.0)
        getPolylineRoute(from: currentLoc, to: caseLoc)
    }
    
    func setupUI() {
       // setBackButton(navigationController: navigationController!, willShowViewController: self, animated: true)
        btnDirection.roundAllCorners(radius: 25.0)
       // mapView.addSubview(btnClose)
        mapView.addSubview(btnDirection)
        mapView.addSubview(btnNavigation)
       // mapView.bringSubview(toFront: btnClose)
        mapView.bringSubview(toFront: btnDirection)
        mapView.bringSubview(toFront: btnNavigation)
    }
    
    
    func setupMap(lat:CLLocationDegrees, lng:CLLocationDegrees) {
        let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        mapView.padding = mapInsets
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lng, zoom: 15.0)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        let position = CLLocationCoordinate2DMake(lat,lng)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage(named:"marker")
        marker.title = "Hello World"
        marker.map = mapView
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
    
    func loadData() {
        
    }
    
    //For Getting Directions
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        showActivityIndicator()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyDsC5JgwQWx_jwvLxk_6AFoE0HnHuHwbeA")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.hideActivityIndicator()
                self.showAlert(title: "Error", message: error!.localizedDescription)
            }else{
                do {
                    if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
                        
                        let routes = json["routes"] as? [[String:Any]]
                        var bounds = GMSCoordinateBounds()
                         DispatchQueue.main.async {
                        for route in routes!
                        {
                            let routeOverviewPolyline = route["overview_polyline"] as? [String:Any]
                            let points = routeOverviewPolyline?["points"] as? String
                            let path = GMSPath.init(fromEncodedPath: points!)
                            
                            let polyline = GMSPolyline(path: path)
                            polyline.strokeColor = .red
                            polyline.strokeWidth = 5.0
                            polyline.map = self.mapView
                            
                            bounds = bounds.includingPath(path!)
                            
                            
                        }
                            self.mapView.animate(with: GMSCameraUpdate.fit(bounds))
                            self.hideActivityIndicator()
                        
//                        let routes = json["routes"] as? [Any]
//                        let overview_polyline = routes?[0] as? [String:Any]
//                        let polyString = overview_polyline?["points"] as? String
                        
                        //Call this method to draw path on map
//                        DispatchQueue.main.async {
//                        self.showPath(polyStr: polyString!)
//                        self.hideActivityIndicator()
//                        }
                        }
                    }
                    
                }catch{
                    self.hideActivityIndicator()
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    
    func showPath(polyStr :String){
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline(path: path)
            polyline.strokeWidth = 3.0
            polyline.map = self.mapView
        
    }
    
    
    func openTrackerInBrowser(destinationLoc:CLLocationCoordinate2D?){
        if destinationLoc?.longitude != nil && destinationLoc?.latitude != nil {
            
            let lat = destinationLoc?.latitude ?? 0.0
            let longi = destinationLoc?.longitude ?? 0.0
            
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(longi)&directionsmode=driving") {
                UIApplication.shared.openURL(urlDestination)
            }
        }
    }
    
}

extension CaseLocationMapWithDirectionsVC : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLat = locValue.latitude
        currentLng = locValue.longitude
        endLocationManager()
        setupMap(lat: caselat ?? 0.0, lng: caselng ?? 0.0)
    }
}
