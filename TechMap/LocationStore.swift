//
//  LocationStore.swift
//  TechMap
//
//  Created by Angelica Bato on 6/9/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import CoreLocation

class LocationStore: NSObject, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!
    var latitude:Double!
    var longitude:Double!
    
    static let sharedDataStore = LocationStore()
    
    override init() {
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        latitude = Double()
        longitude = Double()
    }
    
    func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            print("Location Services enabled.")
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            if (self.locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization))) {
                self.locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Did fail with Error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = locations.last
        self.latitude = self.currentLocation.coordinate.latitude
        self.longitude = self.currentLocation.coordinate.longitude
        self.locationManager.stopUpdatingLocation()
        
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "locationInfoComplete", object: nil))
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {

        switch status {
        case .NotDetermined:
            print("User still thinking...")
            break
        case .Denied:
            print("User hates you")
            break
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            [self.locationManager .startUpdatingLocation()]
            break
        default:
            break
        }
        
    }
    
    
    
    
}
