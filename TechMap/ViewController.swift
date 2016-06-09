//
//  ViewController.swift
//  TechMap
//
//  Created by Angelica Bato on 6/8/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import Alamofire

class ViewController: UIViewController {
    
    var meetupsInCurrentLocation = []
    var dataStore:LocationStore!
    
    var latitude:Double!
    var longitude:Double!
    var location:CLLocation!
    
    var mapView: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView=GMSMapView()
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        mapView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        dataStore = LocationStore()
        dataStore.getLocation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateLocationInfo), name: "locationInfoComplete", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateLocationInfo() {
        latitude = self.dataStore.latitude
        longitude = self.dataStore.longitude
        location = CLLocation(latitude: self.latitude, longitude: self.longitude);
        print("Latitude: \(self.latitude). Longitude: \(self.longitude)")
        
        mapView.camera = GMSCameraPosition(target: self.location.coordinate , zoom: 15.0, bearing: 0, viewingAngle: 0)
        
        self.getMeetupInfo(forCurrentLocation: location) { (response) in
            self.meetupsInCurrentLocation = response
            print(self.meetupsInCurrentLocation)
        }
        
    }
    
    func getMeetupInfo(forCurrentLocation location:CLLocation, completion:([[String:String]]) -> Void) -> Void {
        
        let urlString = "\(meetupsAPIBaseURL)?key=\(meetupAPIKey)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&category=34&sign=true"
        
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    print("JSON results: \(JSON["results"])")
                    
                }
        }
        
    }

}

