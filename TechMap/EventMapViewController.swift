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

class EventMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    //MARK: Properties
    
    var meetupsInCurrentLocation:[EventPlace] = []
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!
    var latitude:Double!
    var longitude:Double!
    
    var coverView:UIView!
    
    var mapView: GMSMapView!
    
    
    // MARK: View Preparation
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        currentLocation = CLLocation()
        latitude = Double()
        longitude = Double()
        
        mapView=GMSMapView()
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.centerXAnchor.constraintEqualToAnchor(self.view.centerXAnchor).active = true
        mapView.centerYAnchor.constraintEqualToAnchor(self.view.centerYAnchor).active = true
        mapView.widthAnchor.constraintEqualToAnchor(self.view.widthAnchor).active = true
        mapView.heightAnchor.constraintEqualToAnchor(self.view.heightAnchor).active = true
        
        mapView.myLocationEnabled = true
        mapView.settings.myLocationButton = true
        
        mapView.delegate = self
        
        coverView = UIView.init(frame: view.frame)
        coverView!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.7)
        
        let label = UILabel()
        label.text = "Please hold while we find tech meetups by you..."
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        label.font = UIFont.init(name: "Avenir", size: 45.0)
        label.textAlignment = .Center
        label.numberOfLines = 0
        
        coverView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraintEqualToAnchor(coverView.widthAnchor, multiplier: 0.75).active = true
        label.heightAnchor.constraintEqualToAnchor(coverView.heightAnchor, multiplier: 0.5).active = true
        label.centerXAnchor.constraintEqualToAnchor(coverView.centerXAnchor).active = true
        label.centerYAnchor.constraintEqualToAnchor(coverView.centerYAnchor).active = true
        
        view.addSubview(coverView!)
        view.bringSubviewToFront(coverView)
        
        getLocation()
        
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        
        meetupsInCurrentLocation = []
        mapView.clear()
        
        view.addSubview(coverView!)
        view.bringSubviewToFront(coverView)

        getLocation()
        
    }
    
    //MARK: Location Services Delegate
    
    func getLocation() {
        let locationServiceOn = CLLocationManager.locationServicesEnabled()
        let appHasLaunchedMoreThanOnce = NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedMoreThanOnce")
        
        if locationServiceOn {
            print("Location Services enabled.")
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            if (locationManager.respondsToSelector(#selector(CLLocationManager.requestWhenInUseAuthorization))) {
                locationManager.requestWhenInUseAuthorization()
            }
            locationManager.startUpdatingLocation()
        }
        else if appHasLaunchedMoreThanOnce{
            let alert = UIAlertController.init(title: "Location Services needed!", message: "Please turn on location services so we can find your current location", preferredStyle: .Alert)
            let settings = UIAlertAction.init(title: "Open Settings", style: .Default, handler: { (action) in
                if let url = NSURL(string:"prefs:root=LOCATION_SERVICES_Systemservices") {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            let cancel = UIAlertAction.init(title: "Cancel", style: .Cancel, handler: nil)
            
            alert.addAction(settings)
            alert.addAction(cancel)
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        let alert = UIAlertController.init(title: "Uh Oh!", message: "We couldn't get your location. Please try again.", preferredStyle: .Alert)
        let ok = UIAlertAction.init(title: "OK", style: .Default, handler: nil)
        alert.addAction(ok)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last
        latitude = currentLocation.coordinate.latitude
        longitude = currentLocation.coordinate.longitude
        locationManager.stopUpdatingLocation()
        
        updateLocationInfo()
                
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            print("User still thinking...")
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .Denied:
            print("User hates you")
            coverView.removeFromSuperview()
            let alert = UIAlertController.init(title: "Sorry!", message: "This app won't work without Location Services Authorization.", preferredStyle: .Alert)
            let action = UIAlertAction.init(title: "Open Settings", style: .Default, handler: { (action) in
                print("User pressed ok")
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            })
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            break
        case .AuthorizedWhenInUse, .AuthorizedAlways:
            self.locationManager.startUpdatingLocation()
            break
        default:
            break
        }
        
    }

    
    
    //MARK: Data Update
    
    func updateLocationInfo() {

        print("Latitude: \(self.latitude). Longitude: \(self.longitude)")
        
        mapView.camera = GMSCameraPosition(target: currentLocation.coordinate , zoom: 15.0, bearing: 0, viewingAngle: 0)
        
        self.getMeetupInfo(forCurrentLocation: currentLocation) { (response) in
            for dict in response {
                let event = EventPlace(dictionary: dict)
                self.meetupsInCurrentLocation.append(event)
            }
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ 
                self.updateMap()
                self.coverView?.removeFromSuperview()
            })
        }
    }
    
    func getMeetupInfo(forCurrentLocation location:CLLocation, completion:([[String:AnyObject]]) -> Void) -> Void {
        
        let urlString = "\(meetupsAPIBaseURL)?key=\(meetupAPIKey)&lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&radius=2&category=34&status=upcoming&sign=true"
        
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let results = JSON["results"] as! [[String:AnyObject]]
                    completion(results)
                }
        }
    }
    
    func updateMap() {
        for event:EventPlace in self.meetupsInCurrentLocation {
            let marker = Placemarker(place: event)
            marker.position = event.coordinate
            marker.map = self.mapView
            marker.infoWindowAnchor = CGPointMake(0.44, 0.45)
        }
        
    }
    
    //MARK: Map Delegate Methods
    
    func mapView(mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        print("Calling delegate method now")
        let placemarker = marker as! Placemarker
        if let infoView = UIView.viewFromNibName("MarkerInfoView") as? MarkerInfoView {
            infoView.nameLabel.text = placemarker.eventplace.name
            infoView.groupLabel.text = placemarker.eventplace.groupName
            infoView.dateLabel.text = placemarker.eventplace.time
            
            return infoView
        }
        
        return nil
    }
    
    func mapView(mapView: GMSMapView, didTapMarker marker: GMSMarker) -> Bool {
        print("Tap Tap")
        mapView.selectedMarker = marker
        return true
    }
    
    func mapView(mapView: GMSMapView, didTapInfoWindowOfMarker marker: GMSMarker) {
        let placemarker = marker as! Placemarker
        let event:EventPlace! = placemarker.eventplace
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("eventDetailVC") as! EventDetailsViewController
        detailVC.event = event
        
        self.presentViewController(detailVC, animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! EventTableViewController
        destVC.events = self.meetupsInCurrentLocation
    }
    
    
    
    
}

