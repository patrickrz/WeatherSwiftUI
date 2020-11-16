//
//  LocationManager.swift
//  WeatherSwiftUI
//
//  Created by Patrick Zhu on 11/12/20.
//
import Foundation
import CoreLocation


class LocationManager: NSObject {

    let locationManager = CLLocationManager()
    static let shared = LocationManager()
    var location: CLLocation?

    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?

    @Published var city: String?

       
    func startLocationManager() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopLocationManager() {
       locationManager.stopUpdatingLocation()
       locationManager.delegate = nil
    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        startLocationManager()
    }
    
    func parsePlacemarks() {
       if let _ = location {
            if let placemark = placemark {
                if let city = placemark.locality, !city.isEmpty {
                    self.city = city
                }
            }
        } else {
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let latestLocation = locations.last!
        location = latestLocation
        geocoder.reverseGeocodeLocation(latestLocation, completionHandler: { (placemarks, error) in
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
            self.parsePlacemarks()

           })
    }
}


