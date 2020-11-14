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
    //LocationManger.shared.parsePlacemarks()
    var location: CLLocation?

    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?

    // here I am declaring the iVars for city and country to access them later
    @Published var city: String?

       
    func startLocationManager() {
        // always good habit to check if locationServicesEnabled
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
    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        let accuracyAuthorization = manager.accuracyAuthorization
//        switch accuracyAuthorization {
//        case .fullAccuracy:
//            break
//        case .reducedAccuracy:
//            break
//        default:
//            break
//        }
//    }
    
    override init() {
        super.init()
        locationManager.requestWhenInUseAuthorization()
        startLocationManager()
    }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // print the error to see what went wrong
//        print("didFailwithError\(error)")
//        // stop location manager if failed
//        stopLocationManager()
//    }
    

    
    func parsePlacemarks() {
       // here we check if location manager is not nil using a _ wild card
       if let _ = location {
            // unwrap the placemark
            if let placemark = placemark {
                // wow now you can get the city name. remember that apple refers to city name as locality not city
                // again we have to unwrap the locality remember optionalllls also some times there is no text so we check that it should not be empty
                if let city = placemark.locality, !city.isEmpty {
                    // here you have the city name
                    // assign city name to our iVar
                    self.city = city
                }
            }
        } else {
           // add some more check's if for some reason location manager is nil
        }

    }
}

//
//
//extension LocationManager: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager,
//                         didChangeAuthorization status: CLAuthorizationStatus) {
//
//        switch status {
//
//        case .notDetermined         : print("notDetermined")        // location permission not asked for yet
//        case .authorizedWhenInUse   : print("authorizedWhenInUse")  // location authorized
//        case .authorizedAlways      : print("authorizedAlways")     // location authorized
//        case .restricted            : print("restricted")           // TODO: handle
//        case .denied                : print("denied")               // TODO: handle
//        }
//    }
//}
//
extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // if you need to get latest data you can get locations.last to check it if the device has been moved
        let latestLocation = locations.last!

        // here check if no need to continue just return still in the same place

        // if it location is nil or it has been moved
        location = latestLocation

        // Here is the place you want to start reverseGeocoding
        geocoder.reverseGeocodeLocation(latestLocation, completionHandler: { (placemarks, error) in
     
                if error == nil, let placemark = placemarks, !placemark.isEmpty {
                    self.placemark = placemark.last
                }
                self.parsePlacemarks()

           })
        
    }

}
//

