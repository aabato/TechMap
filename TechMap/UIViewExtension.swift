//
//  UIViewExtension.swift
//  TechMap
//
//  Created by Angelica Bato on 6/9/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

import UIKit

extension UIView {
    func fadeOut(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 1.0
        }
    }
    
    class func viewFromNibName(name: String) -> UIView? {
        let views = NSBundle.mainBundle().loadNibNamed(name, owner: nil, options: nil)
        return views.first as? UIView
    }
}
