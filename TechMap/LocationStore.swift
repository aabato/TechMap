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
    var latitude:NSString!
    var longitude:NSString!
    
    static let sharedDataStore = LocationStore()
    
    override init() {
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        latitude = NSString()
        longitude = NSString()
    }
    
    func getLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            print("Location Services enabled.")
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.delegate = self
            self.locationManager.requestWhenInUseAuthorization()
            if (self.locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization))) {
                self.locationManager.requestWhenInUseAuthorization()
                print("request for auth made")
            }
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Did fail with Error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.currentLocation = locations.last
        self.latitude = String(format:"%f",self.currentLocation.coordinate.latitude)
        self.longitude = String(format:"%f",self.currentLocation.coordinate.longitude)
        self.locationManager.stopUpdatingLocation()
        
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
