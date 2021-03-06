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
        eventURL = json["event_url"].stringValue
        venueAddress = json["venue"]["address_1"].stringValue
        city = json["venue"]["city"].stringValue
        state = json["venue"]["state"].stringValue
        
        let description_temp = json["description"].stringValue
        description = description_temp.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
        
        var coordinate_temp = CLLocationCoordinate2D()
        coordinate_temp.latitude = json["venue"]["lat"].doubleValue
        coordinate_temp.longitude = json["venue"]["lon"].doubleValue
        coordinate = coordinate_temp
        
        let time_temp = json["time"].doubleValue/1000.0
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        let date = NSDate(timeIntervalSince1970: time_temp)
        time = dateFormatter.stringFromDate(date)
    
    }

}
