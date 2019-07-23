//
//  ViewController.swift
//  MapkitAndCoreLocation
//
//  Created by Annisa Nabila Nasution on 26/06/19.
//  Copyright © 2019 Annisa Nabila Nasution. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
   
    @IBOutlet var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters : Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }

    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled() {
            //setup location manager
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            
        }
    }
    
    func checkLocationAuthorization(){
        switch  CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //saat dijalankan dan location pada iphone nyala
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.longitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

