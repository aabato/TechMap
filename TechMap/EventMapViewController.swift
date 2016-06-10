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

class EventMapViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: Properties
    
    var meetupsInCurrentLocation:[EventPlace] = []
    var dataStore:LocationStore!
    var coverView:UIView!
    
    var latitude:Double!
    var longitude:Double!
    var location:CLLocation!
    
    var mapView: GMSMapView!
    
    
    // MARK: View Preparation
    
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
        
        mapView.delegate = self
        
        coverView = UIView.init(frame: view.frame)
        coverView!.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.6)
        
        let label = UILabel()
        label.text = "Please hold while we find Tech Meetups by you..."
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
        
        dataStore = LocationStore()
        dataStore.getLocation()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventMapViewController.updateLocationInfo), name: "locationInfoComplete", object: nil)
        
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        
        meetupsInCurrentLocation = []
        mapView.clear()
        
        print(meetupsInCurrentLocation)
        
        dataStore = LocationStore()
        dataStore.getLocation()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EventMapViewController.updateLocationInfo), name: "locationInfoComplete", object: nil)
        
    }
    
    //MARK: Data Update
    
    func updateLocationInfo() {
        latitude = self.dataStore.latitude
        longitude = self.dataStore.longitude
        location = CLLocation(latitude: self.latitude, longitude: self.longitude);
        print("Latitude: \(self.latitude). Longitude: \(self.longitude)")
        
        mapView.camera = GMSCameraPosition(target: self.location.coordinate , zoom: 15.0, bearing: 0, viewingAngle: 0)
        
        self.getMeetupInfo(forCurrentLocation: location) { (response) in
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

