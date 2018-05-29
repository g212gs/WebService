//
//  LocationManager.swift
//  WebService
//
//  Created by Gaurang Lathiya on 11/20/17.
//  Copyright © 2017 Gaurang Lathiya. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    
    class var sharedInstance: LocationManager
    {
        //creating Shared Instance
        struct Static
        {
            static let instance: LocationManager = LocationManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
    
    func updateCurrentLocation() {
        manager.requestLocation()
    }
    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            break
        case .notDetermined:
            break
        default:
            if let topController = UIApplication.shared.keyWindow?.rootViewController {
                topController.topMostViewController().showAlert(withTitle: Constants.kApplicationName, message: Constants.kNoLocationInformation)
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
//            print("Found user's location: \(location)")
            LocationManager.fetchCountryAndCity(location: location) { country, state, city in
                // save current location // "Nashik (Maharashtra), India"
                let currentLocation: String = "\(city) (\(state)), \(country)"
                print("Current Location: \(currentLocation)")
                UserDefaults.standard.setValue(currentLocation, forKey: Constants.kUserSavedLocation)
                UserDefaults.standard.synchronize()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        // Remove saved location
        UserDefaults.standard.removeObject(forKey: Constants.kUserSavedLocation)
        UserDefaults.standard.synchronize()
    }
    
    class func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let state = placemarks?.first?.administrativeArea,
                let city = placemarks?.first?.locality {
                completion(country, state, city)
            }
        }
    }
}
