//
//  EventDetailsViewController.swift
//  TechMap
//
//  Created by Angelica Bato on 6/10/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import GoogleMaps
import QuartzCore

class EventDetailsViewController: UIViewController {
    
    var event:EventPlace!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var groupLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.camera = GMSCameraPosition(target: event.coordinate, zoom: 15.0, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker()
        marker.position = event.coordinate
        marker.map = mapView
        
        nameLabel.text = event.name
        groupLabel.text = "Hosted by: \(event.groupName)"
        dateLabel.text = event.time
        addressLabel.text = "\(event.venueAddress),\(event.city),\(event.state)"
        descriptionTextView.text = event.description

    }
    
    @IBAction func getFullDetailsButtonTapped(sender: AnyObject) {
        var url : NSURL
        url = NSURL.init(string: event.eventURL)!
        UIApplication.sharedApplication().openURL(url)
    }

    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
