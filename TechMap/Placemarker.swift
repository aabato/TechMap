//
//  Placemarker.swift
//  TechMap
//
//  Created by Angelica Bato on 6/9/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit
import GoogleMaps

class Placemarker: GMSMarker {
    
    let eventplace:EventPlace!
    
    init(place: EventPlace) {
        self.eventplace = place
        super.init()
        
        position = place.coordinate
        groundAnchor = CGPoint(x:0.5, y:1)
    }

}
