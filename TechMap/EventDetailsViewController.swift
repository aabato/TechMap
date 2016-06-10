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
        
        print("1")
//        mapView = GMSMapView()
//        mapView.animateToLocation(event.coordinate)
//        let marker = Placemarker(place: event)
//        marker.position = event.coordinate
//        marker.map = mapView
        
    
        nameLabel.text = event.name
        groupLabel.text = "Hosted by: \(event.groupName)"
        dateLabel.text = event.time
        addressLabel.text = "\(event.venueAddress),\(event.city),\(event.state)"
        descriptionTextView.text = event.description

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getFullDetailsButtonTapped(sender: AnyObject) {
        var url : NSURL
        url = NSURL.init(string: event.eventURL)!
        UIApplication.sharedApplication().openURL(url)
    }

    @IBAction func closeButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
