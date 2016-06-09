//
//  EventPlace.swift
//  TechMap
//
//  Created by Angelica Bato on 6/9/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import SwiftyJSON

class EventPlace {
    let name: String
    let groupName: String
    let coordinate: CLLocationCoordinate2D
    let description: String
    let eventURL: String
    let venueAddress: String
    let city: String
    let state: String
    let time: String
    
    
    init(dictionary:[String : AnyObject])
    {
        let json = JSON(dictionary)
        name = json["name"].stringValue
        groupName = json["group"]["name"].stringValue
        
        var coordinate_temp = CLLocationCoordinate2D()
        coordinate_temp.latitude = json["venue"]["lat"].doubleValue
        coordinate_temp.longitude = json["venue"]["lon"].doubleValue
        coordinate = coordinate_temp
        
        description = json["description"].stringValue
        eventURL = json["event_url"].stringValue
        venueAddress = json["venue"]["address_1"].stringValue
        city = json["venue"]["city"].stringValue
        state = json["venue"]["state"].stringValue
        
        let time_temp = json["time"].doubleValue
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let date = NSDate(timeIntervalSince1970: time_temp)
        time = dateFormatter.stringFromDate(date)
    
    }

}
