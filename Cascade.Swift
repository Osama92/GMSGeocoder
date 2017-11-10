//
//  ViewController.swift
//  Cascade
//
//  Created by Abdulyekeen Usama Adedayo on 28/10/2017.
//  Copyright © 2017 Abdulyekeen Usama Adedayo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class Cascade: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
  
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var errorView: NSLayoutConstraint!
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()

    }
 

    // Button that closes error when error == true:
    @IBAction func closeError(_ sender: UIButton) {
        self.errorView.constant = -90
        UIView.animate(withDuration: 2.0) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let coordinates = CLLocationCoordinate2D(latitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!)
        
        let camera = GMSCameraPosition.camera(withTarget: coordinates, zoom: 17.0)
        mapView.animate(toZoom: 17.0)
        mapView.isMyLocationEnabled = true
        mapView.isTrafficEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        manager.startUpdatingLocation()
        
        GMSGeocoder().reverseGeocodeCoordinate(coordinates) { (response, error) in
            if error != nil {
                self.errorLabel.text = error?.localizedDescription
                self.errorView.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
                
            }
            else {
                
                if let place = response?.firstResult() {
                    if place.thoroughfare != nil {
                        self.currentLocationLabel.text = "\(place.thoroughfare!)"

                    }
                }
                
            }
           
        }
}
    
    
    
}
