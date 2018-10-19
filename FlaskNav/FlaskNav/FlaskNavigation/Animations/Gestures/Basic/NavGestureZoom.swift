//
//  NavGestureZoom.swift
//  FlaskNav
//
//  Created by hassan uriostegui on 10/14/18.
//  Copyright © 2018 eonflux. All rights reserved.
//

import UIKit

class NavGestureZoom: NavGesture<UIPinchGestureRecognizer> {

    override func newGesture(with selector:Selector)->UIPinchGestureRecognizer {
        let gesture = UIPinchGestureRecognizer.init(target: self, action: selector)
        return gesture
    }

 
    override func progress()->Double {
        guard let gesture = gesture else { return 0}
        
        var percent = min(gesture.scale, 1.0)
        percent = max(percent, 0.0)
        return Double(1.0 - percent)
    }
    
    
}
